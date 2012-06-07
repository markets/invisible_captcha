module InvisibleCaptcha
  module ModelHelpers
    
    def self.included(base)
      base.class_eval {
        attr_accessor :captcha
      }
    end
    
  end
end