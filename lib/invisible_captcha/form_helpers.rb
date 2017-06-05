module InvisibleCaptcha
  module FormHelpers
    def invisible_captcha(honeypot, options = {}, html_options = {})
      @template.invisible_captcha(honeypot, self.object_name, options, html_options)
    end
  end
end