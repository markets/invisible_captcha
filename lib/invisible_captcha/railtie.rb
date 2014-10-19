module InvisibleCaptcha
  class Railtie < Rails::Railtie
    ActionController::Base.send :include, InvisibleCaptcha::ControllerExt
    ActionController::Base.send :extend, InvisibleCaptcha::ControllerExt::ClassMethods
    ActionView::Base.send :include, InvisibleCaptcha::ViewHelpers
    ActionView::Helpers::FormBuilder.send :include, InvisibleCaptcha::FormHelpers
    ActiveModel::Validations::InvisibleCaptchaValidator = InvisibleCaptcha::InvisibleCaptchaValidator
  end
end