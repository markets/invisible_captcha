require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  def helper_output(honeypot = nil, scope = nil, options = {})
    honeypot ||= InvisibleCaptcha.get_honeypot
    input_id   = build_label_name(honeypot, scope)
    input_name = build_text_field_name(honeypot, scope)
    html_id    = generate_html_id(honeypot, scope)
    visibilty  = if options.key?(:visual_honeypots)
      options[:visual_honeypots]
    else
      InvisibleCaptcha.visual_honeypots
    end

    %{
      <div id="#{html_id}">
        <style type="text/css" media="screen" scoped="scoped">#{visibilty ? '' : "##{html_id} { display:none; }"}</style>
        <label for="#{input_id}">#{InvisibleCaptcha.sentence_for_humans}</label>
        <input type="text" name="#{input_name}" id="#{input_id}" />
      </div>
    }.gsub(/\s+/, ' ').strip.gsub('> <', '><')
  end

  before do
    allow(Time).to receive(:now).and_return(Time.parse('Feb 19 1986'))
    InvisibleCaptcha.visual_honeypots = false
  end

  it 'with no arguments' do
    InvisibleCaptcha.honeypots = [:foo_id]
    expect(invisible_captcha).to eq(helper_output)
  end

  it 'with specific honeypot' do
    expect(invisible_captcha(:subtitle)).to eq(helper_output(:subtitle))
  end

  it 'with specific honeypot and scope' do
    expect(invisible_captcha(:subtitle, :topic)).to eq(helper_output(:subtitle, :topic))
  end

  context "honeypot visibilty" do
    it 'visible from defaults' do
      InvisibleCaptcha.honeypots = [:foo_id]
      InvisibleCaptcha.visual_honeypots = true

      expect(invisible_captcha).to eq(helper_output)
    end

    it 'visible from given instance (default override)' do
      InvisibleCaptcha.honeypots = [:foo_id]

      expect(invisible_captcha(visual_honeypots: true)).to eq(helper_output(nil, nil, visual_honeypots: true))
    end

    it 'invisible from given instance (default override)' do
      InvisibleCaptcha.honeypots = [:foo_id]
      InvisibleCaptcha.visual_honeypots = true

      expect(invisible_captcha(visual_honeypots: false)).to eq(helper_output(nil, nil, visual_honeypots: false))
    end
  end
end