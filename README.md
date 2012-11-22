# Invisible Captcha
Don't disturb users. Simple protection for ActiveModels forms using honeypot strategy.

## Installation
Add this line to you Gemfile:
```
gem 'invisible_captcha', :require => 'invisible_captcha', :git => 'git@github.com:markets/invisible_captcha.git'
```
## Usage
In your form:
```ruby
<%= form_for(@topic) do |f| %>
  <%= invisible_captcha 'topic', 'subtitle' %>
<% end %>

```
In your ActiveModel:
```ruby
attr_accessor :subtitle

validates :subtitle, :invisible_captcha => true
```

## License
Copyright (c) 2012 Marc Anguera. Invisible Captcha is released under the [MIT](http://opensource.org/licenses/MIT) License.