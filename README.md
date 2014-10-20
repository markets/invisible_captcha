# Invisible Captcha

[![Gem Version](https://badge.fury.io/rb/invisible_captcha.svg)](http://badge.fury.io/rb/invisible_captcha) [![Build Status](https://travis-ci.org/markets/invisible_captcha.svg)](https://travis-ci.org/markets/invisible_captcha)

Simple and flexible spam protection solution for Rails applications. Based on the `honeypot` strategy to provide a better user experience.

## Background

This strategy is based on adding an input field into the form that:

* shouldn't be visible by the real users
* should be left empty by the real users
* will most be filled by spam bots

## Installation

Add this line to you Gemfile:

```
gem 'invisible_captcha'
```

Or install the gem manually:

```
$ gem install invisible_captcha
```

## Usage

There are different ways to implement, at Controller level or Model level:

### Controller style

View code:

```erb
<%= form_tag(create_topic_path) do |f| %>
  <%= invisible_captcha %>
<% end %>
```

Controller code:

```ruby
class TopicsController < ApplicationController
  invisible_captcha only: [:create, :update]
end
```

This method will add a filter (a `before_filter`) into the controller that triggers when the spam is detected. By default it responds with no content (only headers: `head(200)`). But you are able to define your own callback passing the a method to the `on_spam` option:

```ruby
invisible_captcha only: [:create, :update], on_spam: :your_on_spam_callback_method

private

def your_on_spam_callback_method
  redirect_to root_path
end
```

[Check here the complete list of allowed options.](#controller-method-options)

### Controller style (resource oriented):

In your form:

```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle %>
  <!-- or -->
  <%= invisible_captcha :subtitle, :topic %>
<% end %>
```

In your controller:

```ruby
invisible_captcha only: [:create, :update], honeypot: :subtitle
```

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
  attr_accessor :subtitle # define a virtual attribute, the honeypot
  validates :subtitle, :invisible_captcha => true
end
```

If you are using [strong_parameters](https://github.com/rails/strong_parameters) (by default in Rails 4), don't forget to keep the honeypot attribute into the params hash:

```ruby
def topic_params
  params.require(:topic).permit(:subtitle)
end
```

## Options and customization

This section contains the option list of `invisible_captcha` method (controllers side) and the plugin setup options (initializer).

### Controller method options:

The `invisible_captcha` method accepts some options:

* `only`: apply to given controller actions.
* `except`: exclude to given controller actions.
* `honeypot`: name of honeypot.
* `scope`: name of scope, ie: 'topic[subtitle]' -> 'topic' is the scope.
* `on_spam`: custom callback to be called on spam detection.

### Plugin options:

You also can customize some plugin options:

* `sentence_for_humans`: text for real users if input field was visible.
* `error_message`: error message thrown by model validation (only model implementation).
* `honeypots`: collection of default honeypots, used by the view helper, called with no args, to generate the honeypot field name
* `visual_honeypots`: make honeypots visible, useful to test/debug your implementation.

To change these defaults, add the following to an initializer (recommended `config/initializers/invisible_captcha.rb`):

```ruby
InvisibleCaptcha.setup do |config|
  config.sentence_for_humans = 'If you are a human, ignore this field'
  config.error_message       = 'You are a robot!'
  config.honeypots          += 'fake_resource_title'
  config.visual_honeypots    = false
end
```

## Contribute

Any kind of idea, feedback or bug report are welcome! Open an [issue](https://github.com/markets/invisible_captcha/issues) or send a [pull request](https://github.com/markets/invisible_captcha/pulls).

## Development

Clone/fork the repository and start to hack.

Run test suite:

```
$ rspec
```

Start a sample Rails app ([source code](spec/dummy)) with `InvisibleCaptcha` integrated:

```
$ rake web # PORT=4000 (default: 3000)
```

## License

Copyright (c) 2012-2014 Marc Anguera. Invisible Captcha is released under the [MIT](LICENSE) License.
