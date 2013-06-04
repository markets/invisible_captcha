# Invisible Captcha
Simple protection for ActiveModel forms using honeypot strategy.

## Installation
Add this line to you Gemfile:

```
gem 'invisible_captcha'
```

Or install gem:

```
gem install invisible_captcha
```

## Usage
In your form:

```ruby
<%= form_for(@topic) do |f| %>

  <!-- use form helper -->
  <%= f.invisible_captcha :subtitle %>

  <!-- or use view helper -->
  <%= invisible_captcha :topic, :subtitle %>

<% end %>
```

In your ActiveModel:

```ruby
attr_accessor :subtitle

validates :subtitle, :invisible_captcha => true
```

## License
Copyright (c) 2012 Marc Anguera. Invisible Captcha is released under the [MIT](http://opensource.org/licenses/MIT) License.
