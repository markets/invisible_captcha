# frozen_string_literal: true

module InvisibleCaptcha
  module FormHelpers
    def invisible_captcha(honeypot, options = {})
      @template.invisible_captcha(honeypot, self.object_name, options)
    end
  end
end
