$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'active_model'
require 'action_view'
require 'action_controller'

require 'invisible_captcha'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end


