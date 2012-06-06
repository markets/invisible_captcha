module InvisibleCaptcha
  module ViewHelpers

    def invisible_captcha object
      html_ids = []
      { :a_comment_body => 'If you are a human, do not fill in this field' }.collect do |f, l|
        html_ids << (html_id = "#{f}_inv_cap_#{Time.now.to_i}")
        content_tag :div, :id => html_id do
          content_tag(:style, :type => 'text/css', :media => 'screen', :scoped => "scoped") do
            "#{html_ids.map { |i| "##{i}" }.join(', ')} { display:none; }"
          end +
            label_tag(f, l) +
            text_field_tag("#{object}[#{f}]")
        end
      end.join.html_safe
    end

  end
end

ActionView::Base.send :include, InvisibleCaptcha::ViewHelpers