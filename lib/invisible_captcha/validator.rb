module InvisibleCaptcha
  class InvisibleCaptchaValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if invisible_captcha?(record, attribute)
        record.errors.clear
        record.errors[:base] = InvisibleCaptcha.error_message
      end
    end

    private

    def invisible_captcha?(object, honeypot)
      object.send(honeypot).present?
    end
  end
end