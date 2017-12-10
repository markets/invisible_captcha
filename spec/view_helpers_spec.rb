require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  before(:each) do
    allow(Time.zone).to receive(:now).and_return(Time.zone.parse('Feb 19 1986'))
    @view_flow = ActionView::OutputFlow.new # to test content_for and provide
    InvisibleCaptcha.init!
  end

  it 'with no arguments' do
    InvisibleCaptcha.honeypots = [:foo_id]
    expect(invisible_captcha).to match(/name="foo_id"/)
  end

  it 'with specific honeypot' do
    expect(invisible_captcha(:subtitle)).to match(/name="subtitle"/)
  end

  it 'with specific honeypot and scope' do
    expect(invisible_captcha(:subtitle, :topic)).to match(/name="topic\[subtitle\]"/)
  end

  it 'with custom html options' do
    expect(invisible_captcha(:subtitle, :topic, { class: 'foo_class' })).to match(/class="foo_class"/)
  end

  it 'generated html + styles' do
    InvisibleCaptcha.honeypots = [:foo_id]
    output = invisible_captcha.gsub("\"", "'")
    regexp = %r{<div class='foo_id_\w*'><style .*>.foo_id_\w* {display:none;}</style><label .*>#{InvisibleCaptcha.sentence_for_humans}.*<input .* name='foo_id' .*</div>}

    expect(output).to match(regexp)
  end

  context "honeypot visibilty" do
    it 'visible from defaults' do
      InvisibleCaptcha.visual_honeypots = true

      expect(invisible_captcha).not_to match(/display:none/)
    end

    it 'visible from given instance (default override)' do
      expect(invisible_captcha(visual_honeypots: true)).not_to match(/display:none/)
    end

    it 'invisible from given instance (default override)' do
      InvisibleCaptcha.visual_honeypots = true

      expect(invisible_captcha(visual_honeypots: false)).to match(/display:none/)
    end
  end

  it 'should set spam timestamp' do
    invisible_captcha
    expect(session[:invisible_captcha_timestamp]).to eq(Time.zone.now.iso8601)
  end

  context 'injectable_styles option' do
    it 'by default, render styles along with the honeypot' do
      expect(invisible_captcha).to match(/display:none/)
      expect(helper.content_for(:invisible_captcha_styles)).to be_blank
    end

    it 'if injectable_styles is set, do not append styles inline' do
      InvisibleCaptcha.injectable_styles = true

      expect(invisible_captcha).not_to match(/display:none;/)
      expect(helper.content_for(:invisible_captcha_styles)).to match(/display:none;/)
    end
  end
end
