# Invisible Captcha

[![Gem Version](https://badge.fury.io/rb/invisible_captcha.svg)](http://badge.fury.io/rb/invisible_captcha) [![Build Status](https://travis-ci.org/markets/invisible_captcha.svg)](https://travis-ci.org/markets/invisible_captcha)

Simple and flexible spam protection solution for Rails applications. Based on the `honeypot` strategy to provide a better user experience.

**Background**

The strategy is based on adding an input field into the form that:

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

This method will act as a `before_filter` that triggers when spam is detected (honeypot field has some value). By default it responds with no content (only headers: `head(200)`). But you are able to define your own callback by passing a method to the `on_spam` option:

```ruby
invisible_captcha only: [:create, :update], on_spam: :your_on_spam_callback_method

private

def your_on_spam_callback_method
  redirect_to root_path
end
```

[Check here a complete list of allowed options.](#controller-method-options)

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

This section contains a description of all plugin options and customizations.

### Plugin options:

You can customize:

* `sentence_for_humans`: text for real users if input field was visible. By default, it uses I18n (see below)
* `error_message`: error message thrown by model validation (only model implementation - by default it uses I18n).
* `honeypots`: collection of default honeypots, used by the view helper, called with no args, to generate the honeypot field name
* `visual_honeypots`: make honeypots visible, also useful to test/debug your implementation.
* `timestamp_threshold`: fastest time (4 seconds by default) to expect a human to submit the form (see [original article by Yoav Aner](http://blog.gingerlime.com/2012/simple-detection-of-comment-spam-in-rails/) outlining the idea)
* `timestamp_error_message`: flash error message thrown when form submitted quicker than the `timestamp_threshold` value. It uses I18n by default.

To change these defaults, add the following to an initializer (recommended `config/initializers/invisible_captcha.rb`):

```ruby
InvisibleCaptcha.setup do |config|
  config.honeypots              += 'fake_resource_title'
  config.visual_honeypots        = false
  config.timestamp_threshold     = 4.seconds
  # Leave these unset if you want to use I18n (see below)
  # config.error_message           = 'You are a robot!'
  # config.sentence_for_humans     = 'If you are a human, ignore this field'
  # config.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'
end
```

### Controller method options:

The `invisible_captcha` method accepts some options:

* `only`: apply to given controller actions.
* `except`: exclude to given controller actions.
* `honeypot`: name of honeypot.
* `scope`: name of scope, ie: 'topic[subtitle]' -> 'topic' is the scope.
* `on_spam`: custom callback to be called on spam detection.
* `on_timestamp_spam`: custom callback to be called when form submitted too quickly. The default action redirects to `root_path` printing a warning in `flash[:error]`

### View helpers options:

Using the view/form helper you can override some defaults for the given instance. Actually, it allows to change: `sentence_for_humans` and `visual_honeypots`.

```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle, visual_honeypots: true, sentence_for_humans: "Ei, don't fill on this input!" %>
  <!-- or -->
  <%= invisible_captcha visual_honeypots: true, sentence_for_humans: "Ei, don't fill on this input!" %>
<% end %>
```

### I18n

`invisible_captcha` tries to use I18n when it's available by default. The keys it looks for are the following:

```yaml
en:
  invisible_captcha:
    sentence_for_humans: "If you are human, ignore this field"
    error_message: "You are a robot!"
    timestamp_error_message: "Sorry, that was too quick! Please resubmit."
```

You can override the english ones in your own i18n config files as well as add new ones for other locales.

If you intend to use I18n with `invisible_captcha`, you _must not_ set `sentence_for_humans`, `error_message` or `timestamp_error_message` to strings in the setup phase.

## Contribute

Any kind of idea, feedback or bug report are welcome! Open an [issue](https://github.com/markets/invisible_captcha/issues) or send a [pull request](https://github.com/markets/invisible_captcha/pulls).

## Development

Clone/fork this repository and start to hack.

Run test suite:

```
$ rspec
```

Start a sample Rails app ([source code](spec/dummy)) with `InvisibleCaptcha` integrated:

```
$ rake web # PORT=4000 (default: 3000)
```

## License

Copyright (c) 2012-2015 Marc Anguera. Invisible Captcha is released under the [MIT](LICENSE) License.
