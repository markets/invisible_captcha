module InvisibleCaptcha
  module ViewHelpers
    # Builds the honeypot html
    #
    # @param honeypot [Symbol] name of honeypot, ie: subtitle => input name: subtitle
    # @param scope [Symbol] name of honeypot scope, ie: topic => input name: topic[subtitle]
    # @return [String] the generated html
    def invisible_captcha(honeypot = nil, scope = nil, options = {})
      if InvisibleCaptcha.timestamp_enabled
        session[:invisible_captcha_timestamp] ||= Time.zone.now.iso8601
      end
      build_invisible_captcha(honeypot, scope, options)
    end

    # Adds the honeypot styles to hide the invisible captcha field
    def invisible_captcha_styles
      content_for(:invisible_captcha_styles) if content_for?(:invisible_captcha_styles)
    end

    private

    def build_invisible_captcha(honeypot = nil, scope = nil, options = {})
      if honeypot.is_a?(Hash)
        options = honeypot
        honeypot = nil
      end

      honeypot = honeypot ? honeypot.to_s : InvisibleCaptcha.get_honeypot
      label    = options[:sentence_for_humans] || InvisibleCaptcha.sentence_for_humans
      visual_honeypots = options[:visual_honeypots].nil? ? InvisibleCaptcha.visual_honeypots : options[:visual_honeypots]
      @style_class = options[:style_class_name].presence

      html_id  = generate_html_id(honeypot, scope)

      add_styles unless visual_honeypots

      content_tag(:div, id: html_id, class: invisible_captcha_style_class) do
        concat label_tag(build_label_name(honeypot, scope), label)
        concat text_field_tag(build_text_field_name(honeypot, scope))
      end
    end

    def generate_html_id(honeypot, scope = nil)
      "#{scope || honeypot}_#{Time.zone.now.to_i}"
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

    def add_styles
      provide(:invisible_captcha_styles) do
        content_tag(:style, ".#{invisible_captcha_style_class} {display:none;}")
      end if @view_flow.present?
    end

    def invisible_captcha_style_class
      @style_class ||= invisible_captcha_dynamic_style_class
    end

    def invisible_captcha_dynamic_style_class
      "abcdefghijkl-mnopqrstuvwxyz".chars.sample((10..33).to_a.sample).join
    end
  end
end
