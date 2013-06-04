require 'active_model/validator'

module InvisibleCaptcha
  class InvisibleCaptchaValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      if robot_presence?(record, attribute)
        record.errors.clear
        record.errors[:base] = "YOU ARE A ROBOT!!"
      end
    end

    private

    def robot_presence?(object, attribute)
      object.send(attribute).present?
    end
  
  end
end

ActiveModel::Validations::InvisibleCaptchaValidator = InvisibleCaptcha::InvisibleCaptchaValidator