module InvisibleCaptcha
  module FormHelpers
    def invisible_captcha(honeypot)
      @template.invisible_captcha(self.object_name, honeypot)
    end
  end
end