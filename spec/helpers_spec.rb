require 'spec_helper'

describe InvisibleCaptcha::ViewHelpers, type: :helper do
  def helper_output
    /style media/
  end

  it 'helper' do
    expect(invisible_captcha).to match(helper_output)
  end

  it 'form helper' do
    form = form_for(Topic.new) do |f|
      f.invisible_captcha(:subtitle)
    end

    expect(form).to match(helper_output)
  end
end