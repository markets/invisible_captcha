module InvisibleCaptcha
  module FormHelpers
    def invisible_captcha(honeypot)
      @template.invisible_captcha(honeypot, self.object_name)
    end
  end
end