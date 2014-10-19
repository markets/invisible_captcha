module InvisibleCaptcha
  module ViewHelpers
    def invisible_captcha(resource = nil, method = nil)
      build_invisible_captcha(resource, method)
    end

    private

    def build_invisible_captcha(resource = nil, method = nil)
      resource = resource ? resource.to_s : InvisibleCaptcha.get_honeypot
      label    = InvisibleCaptcha.sentence_for_humans
      html_id  = generate_html_id(resource)

      content_tag(:div, :id => html_id) do
        insert_inline_css(html_id) +
        label_tag(build_label_name(resource, method), label) +
        text_field_tag(build_text_field_name(resource, method))
      end.html_safe
    end

    def generate_html_id(resource)
      "#{resource}_#{Time.now.to_i}"
    end

    def insert_inline_css(container_id)
      content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => 'scoped') do
       "##{container_id} { display:none; }" unless InvisibleCaptcha.visual_honeypots
      end
    end

    def build_label_name(resource, method = nil)
      if method.present?
        "#{resource}_#{method}"
      else
        resource
      end
    end

    def build_text_field_name(resource, method = nil)
      if method.present?
        "#{resource}[#{method}]"
      else
        resource
      end
    end
  end
end