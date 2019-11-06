# frozen_string_literal: true

RSpec.describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  def switchable_post(action, params = {})
    if Rails.version > '5'
      post action, params: params
    else
      post action, params
    end
  end

  def switchable_put(action, params = {})
    if Rails.version > '5'
      put action, params: params
    else
      put action, params
    end
  end

  before(:each) do
    @controller = TopicsController.new
    request.env['HTTP_REFERER'] = 'http://test.host/topics'
    InvisibleCaptcha.init!
    InvisibleCaptcha.timestamp_threshold = 1
  end

  context 'without invisible_captcha_timestamp in session' do
    it 'fails like if it was submitted too fast' do
      switchable_post :create, topic: { title: 'foo' }

      expect(response).to redirect_to 'http://test.host/topics'
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end

    it 'passes if disabled at action level' do
      switchable_post :copy, topic: { title: 'foo' }

      expect(flash[:error]).not_to be_present
      expect(response.body).to be_present
    end

    it 'passes if disabled at app level' do
      InvisibleCaptcha.timestamp_enabled = false
      switchable_post :create, topic: { title: 'foo' }

      expect(flash[:error]).not_to be_present
      expect(response.body).to be_present
    end
  end

  context 'submission timestamp_threshold' do
    before(:each) do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
    end

    it 'fails if submission before timestamp_threshold' do
      switchable_post :create, topic: { title: 'foo' }

      expect(response).to redirect_to 'http://test.host/topics'
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)

      # Make sure session is cleared
      expect(session[:invisible_captcha_timestamp]).to be_nil
    end

    it 'allows a custom on_timestamp_spam callback' do
      switchable_put :update, id: 1, topic: { title: 'bar' }

      expect(response.status).to eq(204)
    end

    it 'allows a new timestamp to be set in the on_timestamp_spam callback' do
      @controller.singleton_class.class_eval do
        def custom_timestamp_callback
          session[:invisible_captcha_timestamp] = 2.seconds.from_now(Time.zone.now).iso8601
          head(204)
        end
      end

      expect { switchable_put :update, id: 1, topic: { title: 'bar' } }
        .to change { session[:invisible_captcha_timestamp] }
        .to be_present
    end

    context 'successful submissions' do
      it 'passes if submission on or after timestamp_threshold' do
        sleep InvisibleCaptcha.timestamp_threshold

        switchable_post :create, topic: {
          title: 'foobar',
          author: 'author',
          body: 'body that passes validation'
        }

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present

        # Make sure session is cleared
        expect(session[:invisible_captcha_timestamp]).to be_nil
      end

      it 'allow to set a custom timestamp_threshold per action' do
        sleep 2 # custom threshold

        switchable_post :publish, id: 1

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present
      end
    end
  end

  context 'honeypot attribute' do
    before(:each) do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
      # Wait for valid submission
      sleep InvisibleCaptcha.timestamp_threshold
    end

    it 'fails with spam' do
      switchable_post :create, topic: { subtitle: 'foo' }

      expect(response.body).to be_blank
    end

    it 'passes with no spam' do
      switchable_post :create, topic: { title: 'foo' }

      expect(response.body).to be_present
    end

    it 'allow a custom on_spam callback' do
      switchable_put :update, id: 1, topic: { subtitle: 'foo' }

      expect(response.body).to redirect_to(new_topic_path)
    end

    it 'honeypot is removed from params if you use a custom honeypot' do
      switchable_post :create, topic: { title: 'foo', subtitle: '' }

      expect(flash[:error]).not_to be_present
      expect(@controller.params[:topic].key?(:subtitle)).to eq(false)
    end
  end
end
