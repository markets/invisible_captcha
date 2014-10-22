require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  def helper_output(honeypot = nil, scope = nil)
    honeypot ||= InvisibleCaptcha.get_honeypot
    input_id   = build_label_name(honeypot, scope)
    input_name = build_text_field_name(honeypot, scope)
    html_id    = generate_html_id(honeypot, scope)

    %{
      <div id="#{html_id}">
        <style media="screen" scoped="scoped" type="text/css">#{InvisibleCaptcha.visual_honeypots ? '' : "##{html_id} { display:none; }"}</style>
        <label for="#{input_id}">#{InvisibleCaptcha.sentence_for_humans}</label>
        <input id="#{input_id}" name="#{input_name}" type="text" />
      </div>
    }.gsub(/\s+/, ' ').strip.gsub('> <', '><')
  end

  before do
    allow(Time).to receive(:now).and_return(Time.parse('Feb 19 1986'))
    InvisibleCaptcha.visual_honeypots = false
  end

  it 'view helper with no arguments' do
    InvisibleCaptcha.honeypots = [:foo_id]
    expect(invisible_captcha).to eq(helper_output)
  end

  it 'view helper with specific honeypot' do
    expect(invisible_captcha(:subtitle)).to eq(helper_output(:subtitle))
  end

  it 'view helper with specific honeypot and scope' do
    expect(invisible_captcha(:subtitle, :topic)).to eq(helper_output(:subtitle, :topic))
  end

  it 'view helper with visual honeypots enabled' do
    InvisibleCaptcha.honeypots = [:foo_id]
    InvisibleCaptcha.visual_honeypots = true

    expect(invisible_captcha).to eq(helper_output)
  end
end