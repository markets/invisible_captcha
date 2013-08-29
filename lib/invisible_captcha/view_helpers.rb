module InvisibleCaptcha
  module ViewHelpers

    def invisible_captcha(model_name, method)
      build_invisible_captcha(model_name.to_s, method.to_s)
    end

    private

    def build_invisible_captcha(model_name, method)
      label      = 'If you are a human, ignore this field'
      html_id    = "#{model_name}_#{Time.now.to_i}"

      content_tag(:div, :id => html_id) do
        insert_inline_css_for(html_id) +
        label_tag("#{model_name}_#{method}", label) +
        text_field_tag("#{model_name}[#{method}]")
      end.html_safe
    end

    def insert_inline_css_for(container_id)
      content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => 'scoped') do
       "##{container_id} { display:none; }"
      end
    end
  end
end

ActionView::Base.send :include, InvisibleCaptcha::ViewHelpers