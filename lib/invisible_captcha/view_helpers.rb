module InvisibleCaptcha
  module ViewHelpers
    # Builds the honeypot html
    #
    # @param honeypot [Symbol] name of honeypot, ie: subtitle => input name: subtitle
    # @param scope [Symbol] name of honeypot scope, ie: topic => input name: topic[subtitle]
    # @return [String] the generated html
    def invisible_captcha(honeypot = nil, scope = nil, options = {})
      session[:invisible_captcha_timestamp] ||= Time.zone.now.iso8601
      build_invisible_captcha(honeypot, scope, options)
    end

    private

    def build_invisible_captcha(honeypot = nil, scope = nil, options = {})
      if honeypot.is_a?(Hash)
        options = honeypot
        honeypot = nil
      end

      honeypot = honeypot ? honeypot.to_s : InvisibleCaptcha.get_honeypot
      label    = options[:sentence_for_humans] || InvisibleCaptcha.sentence_for_humans
      html_id  = generate_html_id(honeypot, scope)

      content_tag(:div, :id => html_id) do
        concat visibility_css(html_id, options)
        concat label_tag(build_label_name(honeypot, scope), label)
        concat text_field_tag(build_text_field_name(honeypot, scope))
      end
    end

    def generate_html_id(honeypot, scope = nil)
      "#{scope || honeypot}_#{Time.zone.now.to_i}"
    end

    def visibility_css(container_id, options)
      visibility = if options.key?(:visual_honeypots)
        options[:visual_honeypots]
      else
        InvisibleCaptcha.visual_honeypots
      end

      content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => 'scoped') do
        "##{container_id} { display:none; }" unless visibility
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
