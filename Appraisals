%w(
  8.0
  7.2
  7.1
  7.0
  6.1
  6.0
  5.2
).each do |version|
  appraise "rails-#{version}" do
    gem "rails", "~> #{version}.0"

    # NOTE: The gem concurrent-ruby no longer loads the logger gem since v1.3.5.
    # More info: https://github.com/rails/rails/pull/54264
    gem "concurrent-ruby", "< 1.3.5"
  end
end
