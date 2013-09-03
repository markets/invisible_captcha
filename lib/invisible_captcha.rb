GEM_PATH = File.dirname(__FILE__) + "/invisible_captcha"
require "#{GEM_PATH}/controller_helpers.rb"
require "#{GEM_PATH}/view_helpers.rb"
require "#{GEM_PATH}/form_helpers.rb"
require "#{GEM_PATH}/validator.rb"

module InvisibleCaptcha
  # Default sentence for humans if text field is visible
  mattr_accessor :sentence_for_humans
  self.sentence_for_humans = 'If you are a human, ignore this field'

  # Default error message for validator
  mattr_accessor :error_message
  self.error_message = 'You are a robot!'

  # Default fake fields for controller based workflow
  mattr_accessor :fake_fields
  self.fake_fields = ['foo_id', 'bar_id', 'baz_id']

  # InvisibleCaptcha.setup do |ic|
  #   ic.sentence_for_humans = 'Another sentence'
  #   ic.error_message = 'Another error message'
  #   ic.fake_fields << 'fake_field'
  # end
  def self.setup
    yield(self)
  end

  def self.fake_field
    self.fake_fields.sample
  end
end