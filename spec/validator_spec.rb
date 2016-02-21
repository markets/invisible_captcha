require 'spec_helper'

describe InvisibleCaptcha::InvisibleCaptchaValidator do
  it 'do not pass validations if honeypot is presented' do
    topic = Topic.new(title: 'foo')
    expect(topic.valid?).to be true

    topic.subtitle = 'foo'
    expect(topic.valid?).to be false
    expect(topic.errors.messages[:base]).to eq [InvisibleCaptcha.error_message]
  end
end
