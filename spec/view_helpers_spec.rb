require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  before(:each) do
    allow(Time.zone).to receive(:now).and_return(Time.zone.parse('Feb 19 1986'))
    allow(InvisibleCaptcha).to receive(:css_strategy).and_return("display:none;")

    # to test content_for and provide
    @view_flow = ActionView::OutputFlow.new

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
    regexp = %r{<div class='foo_id_\w*'><style.*>.foo_id_\w* {display:none;}</style><label.*>#{InvisibleCaptcha.sentence_for_humans}.*<input.*name='foo_id'.*tabindex='-1'.*</div>}

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
      expect(@view_flow.content[:invisible_captcha_styles]).to be_blank
    end

    it 'if injectable_styles is set, do not append styles inline' do
      InvisibleCaptcha.injectable_styles = true

      expect(invisible_captcha).not_to match(/display:none;/)
      expect(@view_flow.content[:invisible_captcha_styles]).to match(/display:none;/)
    end
  end

  context 'disable_autocomplete option' do
    it 'includes the autocomplete="off" html attribute when true' do
      InvisibleCaptcha.disable_autocomplete = true
      expect(invisible_captcha).to match(/input.* autocomplete="off".*>/)
    end

    it 'does not include the autocomplete="off" html attribute when false' do
      InvisibleCaptcha.disable_autocomplete = false
      expect(invisible_captcha).not_to match(/autocomplete="off"/)
    end

    it 'overrides defaults with passed options' do
      pattern = /input.* autocomplete="off".*>/

      InvisibleCaptcha.disable_autocomplete = true
      expect(invisible_captcha(:subtitle, :topic, {})).to match(pattern)
      expect(invisible_captcha(:subtitle, :topic, { disable_autocomplete: true })).to match(pattern)
      expect(invisible_captcha(:subtitle, :topic, { disable_autocomplete: false })).not_to match(pattern)

      InvisibleCaptcha.disable_autocomplete = false
      expect(invisible_captcha(:subtitle, :topic, {})).not_to match(pattern)
      expect(invisible_captcha(:subtitle, :topic, { disable_autocomplete: true })).to match(pattern)
      expect(invisible_captcha(:subtitle, :topic, { disable_autocomplete: false })).not_to match(pattern)
    end
  end
end
