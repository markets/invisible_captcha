require 'invisible_captcha/version'
require 'invisible_captcha/controller_ext'
require 'invisible_captcha/view_helpers'
require 'invisible_captcha/form_helpers'
require 'invisible_captcha/railtie'

module InvisibleCaptcha
  class << self
    attr_writer :sentence_for_humans,
                :timestamp_error_message,
                :error_message

    attr_accessor :honeypots,
                  :timestamp_threshold,
                  :visual_honeypots

    def init!
      # Default sentence for real users if text field was visible
      self.sentence_for_humans = -> { I18n.t('invisible_captcha.sentence_for_humans', default: 'If you are a human, ignore this field') }

      # Default error message for validator
      self.error_message = -> { I18n.t('invisible_captcha.error_message', default: 'You are a robot!') }

      # Default fake fields for controller based workflow
      self.honeypots = ['foo_id', 'bar_id', 'baz_id']

      # Fastest time (in seconds) to expect a human to submit the form
      self.timestamp_threshold = 4

      # Default error message for validator when form submitted too quickly
      self.timestamp_error_message = -> { I18n.t('invisible_captcha.timestamp_error_message', default: 'Sorry, that was too quick! Please resubmit.') }

      # Make honeypots visibles
      self.visual_honeypots = false
    end

    def sentence_for_humans
      call_lambda_or_return(@sentence_for_humans)
    end

    def error_message
      call_lambda_or_return(@error_message)
    end

    def timestamp_error_message
      call_lambda_or_return(@timestamp_error_message)
    end

    def setup
      yield(self) if block_given?
    end

    def get_honeypot
      honeypots.sample
    end

    private

    def call_lambda_or_return(obj)
      obj.respond_to?(:call) ? obj.call : obj
    end
  end
end

InvisibleCaptcha.init!
