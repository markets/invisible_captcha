require 'invisible_captcha/version'
require 'invisible_captcha/controller_ext'
require 'invisible_captcha/view_helpers'
require 'invisible_captcha/form_helpers'
require 'invisible_captcha/validator'
require 'invisible_captcha/railtie'

module InvisibleCaptcha
  class << self
    attr_accessor :sentence_for_humans, :error_message, :fake_fields, :visual_honeypots

    def init!
      # Default sentence for humans if text field is visible
      self.sentence_for_humans = 'If you are a human, ignore this field'

      # Default error message for validator
      self.error_message = 'You are a robot!'

      # Default fake fields for controller based workflow
      self.fake_fields = ['foo_id', 'bar_id', 'baz_id']

      # Enable it to make honeypots visibles
      self.visual_honeypots = false
    end

    # InvisibleCaptcha.setup do |ic|
    #   ic.sentence_for_humans = 'Another sentence'
    #   ic.error_message = 'Another error message'
    #   ic.fake_fields << 'another_fake_field'
    #   ic.visual_honeypots = true
    # end
    def setup
      yield(self) if block_given?
    end

    def fake_field
      fake_fields.sample
    end
  end
end

InvisibleCaptcha.init!