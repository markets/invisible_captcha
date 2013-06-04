module InvisibleCaptcha
  module ViewHelpers

    def invisible_captcha(model_name, attr_name)
      html_ids = []
      { :"#{model_name}" => 'If you are a human, do not fill in this field' }.collect do |field, label|
        html_ids << (html_id = "#{field}_#{Time.now.to_i}")
        content_tag(:div, :id => html_id) do
          content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => "scoped") do
            "#{html_ids.map { |i| "##{i}" }.join(', ')} { display:none; }"
          end +
            label_tag("#{field}_#{attr_name}", label) +
            text_field_tag("#{model_name}[#{attr_name}]")
        end
      end.join.html_safe
    end

  end
end

ActionView::Base.send :include, InvisibleCaptcha::ViewHelpers