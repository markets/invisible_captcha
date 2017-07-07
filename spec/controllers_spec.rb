require 'spec_helper'

describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  def switchable_post(action, **params)
    if ::Rails::VERSION::STRING > '5'
      post action, params: params
    else
      post action, params
    end
  end

  def switchable_put(action, **params)
    if ::Rails::VERSION::STRING > '5'
      put action, params: params
    else
      put action, params
    end
  end

  before do
    @controller = TopicsController.new
    InvisibleCaptcha.timestamp_threshold = 1
    InvisibleCaptcha.timestamp_enabled = true
  end

  context 'without invisible_captcha_timestamp in session' do
    it 'fails like if it was submitted too fast' do
      request.env['HTTP_REFERER'] = 'http://test.host/topics'
      switchable_post :create, topic: { title: 'foo' }

      expect(response).to redirect_to 'http://test.host/topics'
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end
  end

  context 'without invisible_captcha_timestamp in session and timestamp_enabled=false' do
    it 'does not fail like if it was submitted too fast' do
      request.env['HTTP_REFERER'] = 'http://test.host/topics'
      InvisibleCaptcha.timestamp_enabled = false
      switchable_post :create, topic: { title: 'foo' }

      expect(flash[:error]).not_to be_present
      expect(response.body).to be_present
    end
  end

  context 'submission timestamp_threshold' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
    end

    it 'fails if submission before timestamp_threshold' do
      request.env['HTTP_REFERER'] = 'http://test.host/topics'
      switchable_post :create, topic: { title: 'foo' }

      expect(response).to redirect_to 'http://test.host/topics'
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end

    it 'allow custom on_timestamp_spam callback' do
      switchable_put :update, id: 1, topic: { title: 'bar' }

      expect(response).to redirect_to(root_path)
    end

    context 'successful submissions' do
      it 'passes if submission on or after timestamp_threshold' do
        sleep InvisibleCaptcha.timestamp_threshold

        switchable_post :create, topic: { title: 'foo' }

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present
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
    before do
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

    it 'allow custom on_spam callback' do
      switchable_put :update, id: 1, topic: { subtitle: 'foo' }

      expect(response.body).to redirect_to(new_topic_path)
    end
  end
end
