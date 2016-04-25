require 'spec_helper'

describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  before do
    @controller = TopicsController.new
    InvisibleCaptcha.timestamp_threshold = 1
  end

  context 'without invisible_captcha_timestamp in session' do
    it 'fails like if it was submitted too fast' do
      post :create, topic: { title: 'foo' }

      expect(response).to redirect_to(new_topic_path)
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end
  end

  context 'submission timestamp_threshold' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
    end

    it 'fails if submission before timestamp_threshold' do
      post :create, topic: { title: 'foo' }

      expect(response).to redirect_to(new_topic_path)
      expect(flash[:error]).to eq(InvisibleCaptcha.timestamp_error_message)
    end

    it 'allow custom on_timestamp_spam callback' do
      put :update, id: 1, topic: { title: 'bar' }

      expect(response.body).to redirect_to(root_path)
    end

    context 'successful submissions' do
      before do
        # Wait for valid submission
        sleep InvisibleCaptcha.timestamp_threshold
      end

      it 'passes if submission on or after timestamp_threshold' do
        post :create, topic: { title: 'foo' }

        expect(flash[:error]).not_to be_present
        expect(response.body).to be_present
      end
    end
  end

  context 'form field' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
      # Wait for valid submission
      sleep InvisibleCaptcha.timestamp_threshold
    end

    it 'with spam' do
      post :create, topic: { subtitle: 'foo' }

      expect(response.body).to be_blank
    end

    it 'with no spam' do
      post :create, topic: { title: 'foo' }

      expect(response.body).to be_present
    end

    it 'allow custom on_spam callback' do
      put :update, id: 1, topic: { subtitle: 'foo' }

      expect(response.body).to redirect_to(new_topic_path)
    end
  end
end
