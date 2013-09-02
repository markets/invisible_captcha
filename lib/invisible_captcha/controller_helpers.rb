module InvisibleCaptcha
  module ControllerHelpers

    def check_invisible_captcha
      head 200 if params[InvisibleCaptcha.fake_field].present?
    end

  end
end

ActionController::Base.send :include, InvisibleCaptcha::ControllerHelpers
