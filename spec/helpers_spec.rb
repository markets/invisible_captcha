require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  def helper_output
    regexp =
      '<div id="\w*">'\
        '<style media="screen" scoped="scoped" type="text/css">' + (InvisibleCaptcha.visual_honeypots ? '' : '#\w* { display:none; }') + '</style>'\
        '<label for="\w*">' + InvisibleCaptcha.sentence_for_humans + '</label>'\
        '<input id="\w*" name="\w*" type="text" />'\
      '</div>'

    Regexp.new(regexp)
  end

  it 'view helper' do
    expect(invisible_captcha).to match(helper_output)
  end

  it 'view helper with visual honeypots' do
    InvisibleCaptcha.visual_honeypots = true

    expect(invisible_captcha).to match(helper_output)
  end
end