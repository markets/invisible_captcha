require 'spec_helper'

describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  before { @controller = TopicsController.new }

  context 'form field' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now
      # Wait for valid submission
      sleep InvisibleCaptcha.threshold
    end

    # after { travel_back }

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

  context 'submission threshold' do
    before do
      session[:invisible_captcha_timestamp] = Time.zone.now
    end

    it 'fails if submission before threshold' do
      post :create, topic: { title: 'foo' }

      expect(response.body).to have_content(InvisibleCaptcha.threshold_error_message)
    end

    context 'successful submissions' do
      before do
        # Wait for valid submission
        sleep InvisibleCaptcha.threshold
      end

      it 'passes if submission on or after threshold' do
        post :create, topic: { title: 'foo' }

        expect(response.body).not_to have_content('error')
        expect(response.body).to be_present
      end

      it 'allow custom on_timestamp_spam callback' do
        put :update, id: 1, topic: { title: 'bar' }

        expect(response.body).to redirect_to(root_path)
      end
    end
  end
end
