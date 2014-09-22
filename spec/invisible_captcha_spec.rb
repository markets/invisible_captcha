require 'spec_helper'

describe InvisibleCaptcha do
  it 'initialize with defaults' do
    InvisibleCaptcha.init!

    expect(InvisibleCaptcha.sentence_for_humans).to eq('If you are a human, ignore this field')
    expect(InvisibleCaptcha.error_message).to eq('You are a robot!')
    expect(InvisibleCaptcha.fake_fields).to eq(['foo_id', 'bar_id', 'baz_id'])
  end

  it 'allow setup via block' do
    InvisibleCaptcha.setup do |ic|
      ic.sentence_for_humans = 'Another sentence'
    end

    expect(InvisibleCaptcha.sentence_for_humans).to eq('Another sentence')
  end
end