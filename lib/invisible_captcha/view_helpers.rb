module InvisibleCaptcha
  module ViewHelpers
    # Builds the honeypot html
    #
    # @param honeypot [Symbol] name of honeypot, ie: subtitle => input name: subtitle
    # @param scope [Symbol] name of honeypot scope, ie: topic => input name: topic[subtitle]
    # @return [String] the generated html
    def invisible_captcha(honeypot = nil, scope = nil)
      build_invisible_captcha(honeypot, scope)
    end

    private

    def build_invisible_captcha(honeypot = nil, scope = nil)
      honeypot = honeypot ? honeypot.to_s : InvisibleCaptcha.get_honeypot
      label    = InvisibleCaptcha.sentence_for_humans
      html_id  = generate_html_id(honeypot, scope)

      content_tag(:div, :id => html_id) do
        insert_inline_css(html_id) +
        label_tag(build_label_name(honeypot, scope), label) +
        text_field_tag(build_text_field_name(honeypot, scope))
      end.html_safe
    end

    def generate_html_id(honeypot, scope = nil)
      "#{scope || honeypot}_#{Time.now.to_i}"
    end

    def insert_inline_css(container_id)
      content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => 'scoped') do
       "##{container_id} { display:none; }" unless InvisibleCaptcha.visual_honeypots
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