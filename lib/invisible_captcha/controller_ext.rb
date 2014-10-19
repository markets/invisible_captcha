module InvisibleCaptcha
  module ControllerExt
    module ClassMethods
      def invisible_captcha(options = {})
        before_filter(options) do
          detect_spam(options)
        end
      end
    end

    def detect_spam(options = {})
      if invisible_captcha?(options)
        on_spam_action(options)
      end
    end

    def on_spam_action(options = {})
      if action = options[:on_spam]
        send(action)
      else
        default_on_spam
      end
    end

    def default_on_spam
      head(200)
    end

    def invisible_captcha?(options = {})
      honeypot = options[:honeypot]
      resource = options[:resource] || controller_name.singularize

      if honeypot
        return true if params[resource][honeypot].present?
      else
        InvisibleCaptcha.honeypots.each do |field|
          return true if params[field].present?
        end
      end
      false
    end
  end
end