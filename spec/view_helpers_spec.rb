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
    style_attributes, input_attributes = if Gem::Version.new(Rails.version) > Gem::Version.new("4.2.0")
      [
        'type="text/css" media="screen" scoped="scoped"',
        "type=\"text\" name=\"#{input_name}\" id=\"#{input_id}\""
      ]
    else
      [
        'media="screen" scoped="scoped" type="text/css"',
        "id=\"#{input_id}\" name=\"#{input_name}\" type=\"text\""
      ]
    end

    %{
      <div id="#{html_id}">
        <style #{style_attributes}>#{visibilty ? '' : "##{html_id} { display:none; }"}</style>
        <label for="#{input_id}">#{InvisibleCaptcha.sentence_for_humans}</label>
        <input #{input_attributes} />
      </div>
    }.gsub(/\s+/, ' ').strip.gsub('> <', '><')
  end

  before do
    allow(Time.zone).to receive(:now).and_return(Time.zone.parse('Feb 19 1986'))
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

  it 'should set spam timestamp' do
    InvisibleCaptcha.honeypots = [:foo_id]
    invisible_captcha
    expect(session[:invisible_captcha_timestamp]).to eq(Time.zone.now.iso8601)
  end
end
