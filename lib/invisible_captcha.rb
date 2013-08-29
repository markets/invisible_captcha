GEM_PATH = File.dirname(__FILE__) + "/invisible_captcha"
require "#{GEM_PATH}/view_helpers.rb"
require "#{GEM_PATH}/form_helpers.rb"
require "#{GEM_PATH}/validator.rb"

module InvisibleCaptcha

  mattr_accessor :sentence_for_humans
  self.sentence_for_humans = 'If you are a human, ignore this field'

  mattr_accessor :error_message
  self.error_message = 'YOU ARE A ROBOT!'

end