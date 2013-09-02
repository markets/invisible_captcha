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
  self.error_message = 'YOU ARE A ROBOT!'

  # Default fake field name for text_field_tag
  mattr_accessor :fake_field
  self.fake_field = :query

end