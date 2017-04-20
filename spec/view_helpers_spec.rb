require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  def helper_output(honeypot = nil, scope = nil, options = {})
    honeypot ||= InvisibleCaptcha.get_honeypot
    input_id   = build_label_name(honeypot, scope)
    input_name = build_text_field_name(honeypot, scope)
    html_id    = generate_html_id(honeypot, scope)
    html_class = options[:style_class_name] || invisible_captcha_style_class
    visibilty  = if options[:visual_honeypots].nil?
      InvisibleCaptcha.visual_honeypots
    else
      options[:visual_honeypots]
    end
    input_attributes = if Gem::Version.new(Rails.version) > Gem::Version.new("4.2.0")
      "type=\"text\" name=\"#{input_name}\" id=\"#{input_id}\""
    else
      "id=\"#{input_id}\" name=\"#{input_name}\" type=\"text\""
    end

    %{
      <div id="#{html_id}" class="#{html_class}">
        <label for="#{input_id}">#{InvisibleCaptcha.sentence_for_humans}</label>
        <input #{input_attributes} />
      </div>
    }.gsub(/\s+/, ' ').strip.gsub('> <', '><')
  end

  before do
    allow(Time.zone).to receive(:now).and_return(Time.zone.parse('Feb 19 1986'))
    InvisibleCaptcha.visual_honeypots = false
    InvisibleCaptcha.timestamp_enabled = true
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

  it 'with specific style class name' do
    expect(invisible_captcha(style_class_name: "test_class")).to match(/class="test_class"/)
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

  it 'should set spam timestamp' do
    InvisibleCaptcha.honeypots = [:foo_id]
    invisible_captcha
    expect(session[:invisible_captcha_timestamp]).to eq(Time.zone.now.iso8601)
  end
end
