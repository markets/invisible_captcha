module InvisibleCaptcha
  module ControllerExt
    module ClassMethods
      def invisible_captcha(options = {}, &block)
        before_filter(options) do
          check_invisible_captcha
        end
      end
    end

    def check_invisible_captcha
      head 200 if invisible_captcha?
    end

    def invisible_captcha?(fake_resource = nil, fake_field = nil)
      if fake_resource && fake_field
        return true if params[fake_resource][fake_field].present?
      else
        InvisibleCaptcha.fake_fields.each do |field|
          return true if params[field].present?
        end
      end
      false
    end
  end
end