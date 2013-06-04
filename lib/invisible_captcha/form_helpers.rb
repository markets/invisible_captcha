module InvisibleCaptcha
  module FormHelpers

    def invisible_captcha(method)
      @template.invisible_captcha(self.object_name, method)
    end

  end
end

ActionView::Helpers::FormBuilder.send :include, InvisibleCaptcha::FormHelpers