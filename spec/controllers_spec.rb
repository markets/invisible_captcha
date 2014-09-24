require 'spec_helper'

describe InvisibleCaptcha::ControllerExt, type: :controller do
  render_views

  before { @controller = TopicsController.new }

  it 'with spam' do
    post :create, topic: { subtitle: 'foo' }

    expect(response.body).to be_blank
  end

  it 'with no spam' do
    post :create, topic: { title: 'foo' }

    expect(response.body).to be_present
  end
end