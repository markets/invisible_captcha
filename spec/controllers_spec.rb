require 'spec_helper'

describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  before do
    @controller = TopicsController.new
    InvisibleCaptcha.timestamp_threshold = 1
    InvisibleCaptcha.timestamp_enabled = true
  end

  context 'without invisible_captcha_timestamp in session' do
    it 'fails like if it was submitted too fast' do
      request.env['HTTP_REFERER'] = 'http://test.host/topics'
      post :create, params: { topic: { title: 'foo' } }

      expect(response).to redirect_to :back
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end
  end

  context 'without invisible_captcha_timestamp in session and timestamp_enabled=false' do
    it 'does not fail like if it was submitted too fast' do
      request.env['HTTP_REFERER'] = 'http://test.host/topics'
      InvisibleCaptcha.timestamp_enabled = false
      post :create, params: { topic: { title: 'foo' } }

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
      post :create, params: { topic: { title: 'foo' } }

      expect(response).to redirect_to :back
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end

    it 'allow custom on_timestamp_spam callback' do
      put :update, params: { id: 1, topic: { title: 'bar' } }

      expect(response).to redirect_to(root_path)
    end

    context 'successful submissions' do
      it 'passes if submission on or after timestamp_threshold' do
        sleep InvisibleCaptcha.timestamp_threshold

        post :create, params: { topic: { title: 'foo' } }

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present
      end

      it 'allow to set a custom timestamp_threshold per action' do
        sleep 2 # custom threshold

        post :publish, params: { id: 1 }

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present
      end
    end
  end

  context 'styles' do
    it 'adds hidding styles by default' do
      allow_any_instance_of(InvisibleCaptcha::ViewHelpers).to receive(:invisible_captcha_dynamic_style_class).and_return('test')
      get :new

      expect(response.body.include?('<style>.test {display:none;}</style>')).to eq(true)
    end

    it 'does not add styles in visual_honeypots context' do
      get :new, params: { context: 'visual_honeypots' }

      expect(response.body.include?('<style>')).to eq(false)
    end
  end

  context 'honeypot attribute' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
      # Wait for valid submission
      sleep InvisibleCaptcha.timestamp_threshold
    end

    it 'fails with spam' do
      post :create, params: { topic: { subtitle: 'foo' } }

      expect(response.body).to be_blank
    end

    it 'passes with no spam' do
      post :create, params: { topic: { title: 'foo' } }

      expect(response.body).to be_present
    end

    it 'allow custom on_spam callback' do
      put :update, params: { id: 1, topic: { subtitle: 'foo' } }

      expect(response.body).to redirect_to(new_topic_path)
    end
  end
end
