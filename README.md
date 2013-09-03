# Invisible Captcha
Simple spam protection for Rails applications using honeypot strategy and for better user experience. Support for ActiveRecord (and ActiveModel) forms and for non-RESTful resources.

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

### Model style
View code:

```erb
<%= form_for(@topic) do |f| %>

  <!-- You can use form helper -->
  <%= f.invisible_captcha :subtitle %>

  <!-- or view helper -->
  <%= invisible_captcha :topic, :subtitle %>

<% end %>
```

Model code:

```ruby
validates :subtitle, :invisible_captcha => true
```

### Controller style
View code:

```erb
<%= form_tag(search_path) do %>

  <%= invisible_captcha %>

<% end %>
```

Controller code:

```ruby
before_filter :check_invisible_captcha, :only => [:create, :update]
```

This filter returns a response that has no content (only headers). If you desire a different behaviour, this lib provides a method to check manualy if invisible captcha (fake field) is present:

```ruby
if invisible_captcha?
  # invalid
else
  # valid
end
```

If you want to use it in this way but using RESTful forms with `form_for`, you can call this method with the fake field as a parameters:

```ruby
if invisible_captcha?(:topic, :subtitle)
  # invalid
else
  # valid
end
```

### Setup
If you want to customize some defaults, add the following to an initializer (config/initializers/invisible_captcha.rb):

```
InvisibleCaptcha.setup do |ic|
  ic.sentence_for_humans = 'Another sentence'
  ic.error_message = 'Another error message'
  ic.fake_fields << 'fake_field'
end
```

## License
Copyright (c) 2012 Marc Anguera. Invisible Captcha is released under the [MIT](http://opensource.org/licenses/MIT) License.
