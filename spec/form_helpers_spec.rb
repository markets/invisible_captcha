RSpec.describe InvisibleCaptcha::FormHelpers, type: :helper do
  let(:object_name) { 'object_name' }

  before(:each) do
    @template = double

    InvisibleCaptcha.init!
  end

  it 'with no arguments' do
    InvisibleCaptcha.honeypots = [:foo_id]

    expect(@template).to receive(:invisible_captcha).with(nil, object_name, {})

    invisible_captcha
  end
end
