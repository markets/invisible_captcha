module InvisibleCaptcha
  module ViewHelpers

    def invisible_captcha(model_name, method)
      build_invisible_captcha(model_name.to_s, method.to_s)
    end

    protected

    def build_invisible_captcha(model_name, method)
      html_ids = []
      { :"#{model_name}" => 'If you are a human, do not fill in this field' }.collect do |field, label|
        html_ids << (html_id = "#{field}_#{Time.now.to_i}")
        content_tag(:div, :id => html_id) do
          content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => "scoped") do
            "#{html_ids.map { |i| "##{i}" }.join(', ')} { display:none; }"
          end +
            label_tag("#{field}_#{method}", label) +
            text_field_tag("#{model_name}[#{method}]")
        end
      end.join.html_safe
    end

  end
end

ActionView::Base.send :include, InvisibleCaptcha::ViewHelpers