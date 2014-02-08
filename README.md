# Invisible Captcha

[![Gem Version](https://badge.fury.io/rb/invisible_captcha.png)](http://badge.fury.io/rb/invisible_captcha)

Simple and flexible spam protection solution for Rails applications using honeypot strategy and for better user experience.
Support for ActiveRecord (and ActiveModel) forms and for non-RESTful resources.

## Installation
Add this line to you Gemfile:

```
gem 'invisible_captcha'
```

Or install gem manually:

```
gem install invisible_captcha
```

## Usage
There are different ways to implement:

### Model style
View code:

```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle %>
<% end %>
```

Model code:

```ruby
class Topic < ActiveRecord::Base
  attr_accessor :subtitle # virtual attribute, the honeypot
  validates :subtitle, :invisible_captcha => true
end
```

If you are using [strong_parameters](https://github.com/rails/strong_parameters), don't forget to keep the honeypot attribute into the params hash:
```ruby
def topic_params
  params.require(:topic).permit(:subtitle)
end
```

### Controller style
View code:

```erb
<%= form_for(@topic) do |f| %>
  <%= invisible_captcha %>
<% end %>
```

Controller code:

```ruby
class TopicsController < ApplicationController
  before_filter :check_invisible_captcha # :only => [:create, :update]
  # your controller code
end
```

This filter triggers when the spam is the in params and responds without content (only headers). If you desire a different behaviour, you can use a provided method to check manualy if invisible captcha (fake field) is present:

```ruby
if invisible_captcha?
  # spam present
else
  # no spam
end
```

### Controller style (resource oriented):

In your form:
```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle %>
<% end %>
```

In your controller:
```ruby
def create
  if invisible_captcha?(:topic, :subtitle)
    head 200 # or redirect_to new_topic_path
  else
    # regular workflow
  end
end
```

### Setup
If you want to customize some defaults, add the following to an initializer (config/initializers/invisible_captcha.rb):

```ruby
InvisibleCaptcha.setup do |ic|
  ic.sentence_for_humans = 'If you are a human, ignore this field'
  ic.error_message = 'You are a robot!'
  ic.fake_fields << 'another_fake_field'
end
```

## License
Copyright (c) 2012-2014 Marc Anguera. Invisible Captcha is released under the [MIT](LICENSE) License.
