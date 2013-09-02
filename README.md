# Invisible Captcha
Simple spam protection for Rails applications using honeypot strategy. Support for ActiveModel (and ActiveRecord) forms and for non-RESTful resources.

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

### RESTful style
In your form:

```html
<%= form_for(@topic) do |f| %>

  <!-- You can use form helper -->
  <%= f.invisible_captcha :subtitle %>

  <!-- or view helper -->
  <%= invisible_captcha :topic, :subtitle %>

<% end %>
```

In your model:

```ruby
validates :subtitle, :invisible_captcha => true
```

### Non-RESTful style
In your form:

```html
<%= form_tag(search_path) do %>

  <%= invisible_captcha %>

<% end %>
```

In your controller:

```ruby
before_filter :check_invisible_captcha
```

## License
Copyright (c) 2012 Marc Anguera. Invisible Captcha is released under the [MIT](http://opensource.org/licenses/MIT) License.
