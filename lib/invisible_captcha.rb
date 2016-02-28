require 'invisible_captcha/version'
require 'invisible_captcha/controller_ext'
require 'invisible_captcha/view_helpers'
require 'invisible_captcha/form_helpers'
require 'invisible_captcha/validator'
require 'invisible_captcha/railtie'

module InvisibleCaptcha
  class << self
    attr_accessor :sentence_for_humans,
                  :error_message,
                  :honeypots,
                  :timestamp_threshold,
                  :timestamp_error_message,
                  :visual_honeypots

    def init!
      # Default sentence for real users if text field was visible
      self.sentence_for_humans = 'If you are a human, ignore this field'

      # Default error message for validator
      self.error_message = 'You are a robot!'

      # Default fake fields for controller based workflow
      self.honeypots = ['foo_id', 'bar_id', 'baz_id']

      # Fastest time to expect a human to submit the form
      self.timestamp_threshold = 10.seconds

      # Default error message for validator when form submitted too quickly
      self.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'

      # Make honeypots visibles
      self.visual_honeypots = false
    end

    def setup
      yield(self) if block_given?
    end

    def get_honeypot
      honeypots.sample
    end
  end
end

InvisibleCaptcha.init!
