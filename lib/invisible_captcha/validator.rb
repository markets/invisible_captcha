require 'active_model/validator'

module InvisibleCaptcha
  class InvisibleCaptchaValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if invisible_captcha?(record, attribute)
        record.errors.clear
        record.errors[:base] = InvisibleCaptcha.error_message
      end
    end

    private

    def invisible_captcha?(object, attribute)
      object.send(attribute).present?
    end
  end
end