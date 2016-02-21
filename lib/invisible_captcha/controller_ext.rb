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
      if invisible_captcha_threshold?(options)
        on_threshold_spam_action(options)
      end
    end

    def detect_threshold_spam(options = {})
      if invisible_captcha_threshold?(options)
        on_threshold_spam_action(options)
      end
    end

    def on_spam_action(options = {})
      if action = options[:on_spam]
        send(action)
      else
        default_on_spam
      end
    end

    def on_threshold_spam_action(options = {})
      if action = options[:on_threshold_spam]
        send(action)
      else
        flash[:error] = InvisibleCaptcha.threshold_error_message
      end
    end

    def default_on_spam
      head(200)
    end

    def invisible_captcha?(options = {})
      honeypot = options[:honeypot]
      scope    = options[:scope] || controller_name.singularize

      if honeypot
        # If honeypot is presented, search for:
        # - honeypot: params[:subtitle]
        # - honeypot with scope: params[:topic][:subtitle]
        if params[honeypot].present? || (params[scope] && params[scope][honeypot].present?)
          return true
        end
      else
        InvisibleCaptcha.honeypots.each do |field|
          return true if params[field].present?
        end
      end
      false
    end

    def invisible_captcha_threshold?(options = {})
      timestamp       = session[:invisible_captcha_timestamp]
      time_to_submit  = Time.zone.now - timestamp

      # Consider as spam if form submitted too quickly
      if timestamp && time_to_submit < InvisibleCaptcha.threshold
        logger.warn("Potential spam detected for IP #{request.env['REMOTE_ADDR']}. Invisible Captcha threshold not reached (took #{time_to_submit.to_i}s).")
        return true
      end
      false
    end
  end
end
