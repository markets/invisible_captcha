module InvisibleCaptcha
  module ViewHelpers
    # Builds the honeypot html
    #
    # @param honeypot [Symbol] name of honeypot, ie: subtitle => input name: subtitle
    # @param scope [Symbol] name of honeypot scope, ie: topic => input name: topic[subtitle]
    # @param options [Hash] html_options for input and invisible_captcha options
    #
    # @return [String] the generated html
    def invisible_captcha(honeypot = nil, scope = nil, options = {})
      if InvisibleCaptcha.timestamp_enabled
        session[:invisible_captcha_timestamp] = Time.zone.now.iso8601
      end
      build_invisible_captcha(honeypot, scope, options)
    end

    def invisible_captcha_styles
      if content_for?(:invisible_captcha_styles)
        content_for(:invisible_captcha_styles)
      end
    end

    private

    def build_invisible_captcha(honeypot = nil, scope = nil, options = {})
      if honeypot.is_a?(Hash)
        options = honeypot
        honeypot = nil
      end

      honeypot  = honeypot ? honeypot.to_s : InvisibleCaptcha.get_honeypot
      label     = options.delete(:sentence_for_humans) || InvisibleCaptcha.sentence_for_humans
      css_class = "#{honeypot}_#{Time.zone.now.to_i}"

      styles = visibility_css(css_class, options)

      provide(:invisible_captcha_styles) do
        styles
      end if InvisibleCaptcha.injectable_styles

      content_tag(:div, class: css_class, aria: { hidden: true }) do
        concat styles unless InvisibleCaptcha.injectable_styles
        concat label_tag(build_label_name(honeypot, scope), label)
        concat text_field_tag(build_text_field_name(honeypot, scope), nil, options.merge(tabindex: -1))
      end
    end

    def visibility_css(css_class, options)
      visible = if options.key?(:visual_honeypots)
        options.delete(:visual_honeypots)
      else
        InvisibleCaptcha.visual_honeypots
      end

      return if visible

      content_tag(:style, media: 'screen') do
        ".#{css_class} {#{InvisibleCaptcha.css_strategy}}"
      end
    end

    def build_label_name(honeypot, scope = nil)
      if scope.present?
        "#{scope}_#{honeypot}"
      else
        honeypot
      end
    end

    def build_text_field_name(honeypot, scope = nil)
      if scope.present?
        "#{scope}[#{honeypot}]"
      else
        honeypot
      end
    end
  end
end
