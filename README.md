# Invisible Captcha

[![Gem Version](https://badge.fury.io/rb/invisible_captcha.svg)](http://badge.fury.io/rb/invisible_captcha) [![Build Status](https://travis-ci.org/markets/invisible_captcha.svg)](https://travis-ci.org/markets/invisible_captcha)

> Simple and flexible spam protection solution for Rails applications.

It is based on the `honeypot` strategy to provide a better user experience. It also provides a time-sensitive form submission.

**Background**

The strategy is about adding an input field into the form that:

* shouldn't be visible by the real users
* should be left empty by the real users
* will most be filled by spam bots

## Installation

Invisible Captcha is tested against Rails `>= 3.2` and Ruby `>= 1.9.3`.

Add this line to you Gemfile:

```
gem 'invisible_captcha'
```

Or install the gem manually:

```
$ gem install invisible_captcha
```

## Usage

View code:

```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle %>
  <!-- or -->
  <%= invisible_captcha :subtitle, :topic %>
<% end %>
```

Controller code:

```ruby
class TopicsController < ApplicationController
  invisible_captcha only: [:create, :update], honeypot: :subtitle
end
```

This method will act as a `before_filter` that triggers when spam is detected (honeypot field has some value). By default it responds with no content (only headers: `head(200)`). This is a good default, since the bot will surely read the response code and will think that it has achieved to submit the form properly. But, anyway, you are able to define your own callback by passing a method to the `on_spam` option:

```ruby
class TopicsController < ApplicationController
  invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  private

  def your_spam_callback_method
    redirect_to root_path
  end
end
```

Note that isn't mandatory to specify a `honeypot` attribute (nor in the view, nor in the controller). In this case, the engine will take a random field from `InvisibleCaptcha.honeypots`. So, if you're integrating it following this path, in your form:

```erb
<%= form_tag(new_contact_path) do |f| %>
  <%= invisible_captcha %>
<% end %>
```

In you controller:

```
invisible_captcha only: [:new_contact]
```

## Options and customization

This section contains a description of all plugin options and customizations.

### Plugin options:

You can customize:

* `sentence_for_humans`: text for real users if input field was visible. By default, it uses I18n (see below).
* `honeypots`: collection of default honeypots. Used by the view helper, called with no args, to generate a random honeypot field name.
* `visual_honeypots`: make honeypots visible, also useful to test/debug your implementation.
* `timestamp_threshold`: fastest time (in seconds) to expect a human to submit the form (see [original article by Yoav Aner](http://blog.gingerlime.com/2012/simple-detection-of-comment-spam-in-rails/) outlining the idea). By default, 4 seconds. **NOTE:** It's recommended to deactivate the autocomplete feature to avoid false positives (`autocomplete="off"`).
* `timestamp_error_message`: flash error message thrown when form submitted quicker than the `timestamp_threshold` value. It uses I18n by default.

To change these defaults, add the following to an initializer (recommended `config/initializers/invisible_captcha.rb`):

```ruby
InvisibleCaptcha.setup do |config|
  config.honeypots              += 'fake_resource_title'
  config.visual_honeypots        = false
  config.timestamp_threshold     = 4
  # Leave these unset if you want to use I18n (see below)
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
* `on_timestamp_spam`: custom callback to be called when form submitted too quickly. The default action redirects to `:back` printing a warning in `flash[:error]`.
* `timestamp_threshold`: custom threshold per controller/action. Overrides the global value for `InvisibleCaptcha.timestamp_threshold`.

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
    timestamp_error_message: "Sorry, that was too quick! Please resubmit."
```

You can override the english ones in your own i18n config files as well as add new ones for other locales.

If you intend to use I18n with `invisible_captcha`, you _must not_ set `sentence_for_humans` or `timestamp_error_message` to strings in the setup phase.

## Contribute

Any kind of idea, feedback or bug report are welcome! Open an [issue](https://github.com/markets/invisible_captcha/issues) or send a [pull request](https://github.com/markets/invisible_captcha/pulls).

## Development

Clone/fork this repository, start to hack on it and send a pull request.

Run the test suite:

```
$ bundle exec rspec
```

Run the test suite against all supported versions:

```
$ bundle exec appraisal rake
```

Start a sample Rails app ([source code](spec/dummy)) with `InvisibleCaptcha` integrated:

```
$ bundle exec rake web # PORT=4000 (default: 3000)
```

## License

Copyright (c) 2012-2016 Marc Anguera. Invisible Captcha is released under the [MIT](LICENSE) License.
