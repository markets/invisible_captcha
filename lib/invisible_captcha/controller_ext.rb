# frozen_string_literal: true

module InvisibleCaptcha
  module ControllerExt
    module ClassMethods
      
      def invisible_captcha(options = {})
        helper_method :invisible_captcha_timestamp, :invisible_captcha_spinner_value
        
        if options.key?(:prepend)
          prepend_before_action(options) do
            detect_spam(options)
          end
        else
          before_action(options) do
            detect_spam(options)
          end
        end
      end
    end

    private
    
    def invisible_captcha_timestamp
      if session[:invisible_captcha_timestamp].present?
        t= session[:invisible_captcha_timestamp]
      else
        t= Time.zone.now.iso8601
      end
      @invisible_captcha_timestamp ||= t
    end

    def invisible_captcha_spinner_value
       @invisible_captcha_spinner_value ||= InvisibleCaptcha.encode("#{invisible_captcha_timestamp}-#{request.remote_ip}")
    end

    def detect_spam(options = {})
      if ip_spam?(options)
        on_spam(options)
      elsif timestamp_spam?(options)
        on_timestamp_spam(options)
      elsif honeypot_spam?(options)
        on_spam(options)
      end
    end

    def on_timestamp_spam(options = {})
      if action = options[:on_timestamp_spam]
        send(action)
      else
        redirect_back(fallback_location: root_path, flash: { error: InvisibleCaptcha.timestamp_error_message })
      end
    end

    def on_spam(options = {})
      if action = options[:on_spam]
        send(action)
      else
        head(200)
      end
    end

    def timestamp_spam?(options = {})
      enabled = if options.key?(:timestamp_enabled)
        options[:timestamp_enabled]
      else
        InvisibleCaptcha.timestamp_enabled
      end

      return false unless enabled

      @invisible_captcha_timestamp ||= session.delete(:invisible_captcha_timestamp)

      # Consider as spam if timestamp not in session, cause that means the form was not fetched at all
      unless @invisible_captcha_timestamp
        warn_spam("Invisible Captcha timestamp not found in session.")
        return true
      end

      time_to_submit = Time.zone.now - DateTime.iso8601(@invisible_captcha_timestamp)
      threshold = options[:timestamp_threshold] || InvisibleCaptcha.timestamp_threshold

      # Consider as spam if form submitted too quickly
      if time_to_submit < threshold
        warn_spam("Invisible Captcha timestamp threshold not reached (took #{time_to_submit.to_i}s).")
        return true
      end

      return false
    end
    
    def ip_spam?(options ={})
      honeypot = options[:honeypot]
      scope    = options[:scope] || controller_name.singularize

      if InvisibleCaptcha.ip_enabled
        if params[:spinner] == invisible_captcha_spinner_value || (params[scope] && params[scope][:spinner] == invisible_captcha_spinner_value) 
          # remove spinner from params to avoid UnpermittedParameters exceptions
          params.delete(:spinner) if params.key?(:spinner)
          params[scope].try(:delete, :spinner) if params.key?(scope)
        else
          warn_spam("Invisible Captcha spinner value mismatch")
          return true
        end 
      end
      false
    end
    
    def honeypot_spam?(options = {})     
      honeypot = options[:honeypot]
      scope    = options[:scope] || controller_name.singularize
 
      if honeypot
        # If honeypot is defined for this controller-action, search for:
        # - honeypot: params[:subtitle]
        # - honeypot with scope: params[:topic][:subtitle]
        if params[honeypot].present? || (params[scope] && params[scope][honeypot].present?)
          warn_spam("Invisible Captcha honeypot param '#{honeypot}' was present.")
          return true
        else
          # No honeypot spam detected, remove honeypot from params to avoid UnpermittedParameters exceptions
          params.delete(honeypot) if params.key?(honeypot)
          params[scope].try(:delete, honeypot) if params.key?(scope)
        end
      else
        InvisibleCaptcha.honeypots.each do |default_honeypot|
          if params[default_honeypot].present?
            warn_spam("Invisible Captcha honeypot param '#{default_honeypot}' was present.")
            return true
          end
        end
      end

      false
    end

    def warn_spam(message)
      logger.warn("Potential spam detected for IP #{request.remote_ip}. #{message}")

      ActiveSupport::Notifications.instrument(
        'invisible_captcha.spam_detected',
        message: message,
        remote_ip: request.remote_ip,
        user_agent: request.user_agent,
        controller: params[:controller],
        action: params[:action],
        url: request.url,
        params: request.filtered_parameters
      )
    end
  end
end
