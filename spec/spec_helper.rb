$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV['RAILS_ENV'] = 'test'
require File.expand_path("../dummy/config/environment.rb", __FILE__)

require 'rspec/rails'

require 'invisible_captcha'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
