# Invisible Captcha

[![Gem Version](https://badge.fury.io/rb/invisible_captcha.svg)](http://badge.fury.io/rb/invisible_captcha) [![Build Status](https://travis-ci.org/markets/invisible_captcha.svg)](https://travis-ci.org/markets/invisible_captcha)

> Simple and flexible spam protection solution for Rails applications.

Invisible Captcha provides different techniques to protect your application against spambots.

The main protection is a solution based on the `honeypot` principle, which provides a better user experience, since there is no extra steps for real users, but for the bots.

Essentially, the strategy consists on adding an input field :honey_pot: into the form that:

* shouldn't be visible by the real users
* should be left empty by the real users
* will most be filled by spam bots

It also comes with a time-sensitive :hourglass: form submission.

## Installation

Invisible Captcha is tested against Rails `>= 3.2` and Ruby `>= 2.2`.

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

This method will act as a `before_action` that triggers when spam is detected (honeypot field has some value). By default it responds with no content (only headers: `head(200)`). This is a good default, since the bot will surely read the response code and will think that it has achieved to submit the form properly. But, anyway, you are able to define your own callback by passing a method to the `on_spam` option:

```ruby
class TopicsController < ApplicationController
  invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  private

  def your_spam_callback_method
    redirect_to root_path
  end
end
```

Note that is not mandatory to specify a `honeypot` attribute (nor in the view, nor in the controller). In this case, the engine will take a random field from `InvisibleCaptcha.honeypots`. So, if you're integrating it following this path, in your form:

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
* `honeypots`: collection of default honeypots. Used by the view helper, called with no args, to generate a random honeypot field name. By default, a random collection is already generated.
* `visual_honeypots`: make honeypots visible, also useful to test/debug your implementation.
* `timestamp_threshold`: fastest time (in seconds) to expect a human to submit the form (see [original article by Yoav Aner](http://blog.gingerlime.com/2012/simple-detection-of-comment-spam-in-rails/) outlining the idea). By default, 4 seconds. **NOTE:** It's recommended to deactivate the autocomplete feature to avoid false positives (`autocomplete="off"`).
* `timestamp_enabled`: option to disable the time threshold check at application level. Could be useful, for example, on some testing scenarios. By default, true.
* `timestamp_error_message`: flash error message thrown when form submitted quicker than the `timestamp_threshold` value. It uses I18n by default.
* `injectable_styles`: if enabled, you should call anywhere in your layout the following helper `<%= invisible_captcha_styles %>`. This allows you to inject styles, for example, in `<head>`. False by default, styles are injected inline with the honeypot.

To change these defaults, add the following to an initializer (recommended `config/initializers/invisible_captcha.rb`):

```ruby
InvisibleCaptcha.setup do |config|
  # config.honeypots           << ['more', 'fake', 'attribute', 'names']
  # config.visual_honeypots    = false
  # config.timestamp_threshold = 4
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false

  # Leave these unset if you want to use I18n (see below)
  # config.sentence_for_humans     = 'If you are a human, ignore this field'
  # config.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'
end
```

### Controller method options:

The `invisible_captcha` method accepts some options:

* `only`: apply to given controller actions.
* `except`: exclude to given controller actions.
* `honeypot`: name of custom honeypot.
* `scope`: name of scope, ie: 'topic[subtitle]' -> 'topic' is the scope.
* `on_spam`: custom callback to be called on spam detection.
* `timestamp_threshold`: enable/disable this technique at action level.
* `on_timestamp_spam`: custom callback to be called when form submitted too quickly. The default action redirects to `:back` printing a warning in `flash[:error]`.
* `timestamp_threshold`: custom threshold per controller/action. Overrides the global value for `InvisibleCaptcha.timestamp_threshold`.

### View helpers options:

Using the view/form helper you can override some defaults for the given instance. Actually, it allows to change: `sentence_for_humans` and `visual_honeypots`.

```erb
<%= form_for(@topic) do |f| %>
  <%= f.invisible_captcha :subtitle, visual_honeypots: true, sentence_for_humans: "hey! leave this input empty!" %>
  <!-- or -->
  <%= invisible_captcha visual_honeypots: true, sentence_for_humans: "hey! leave this input empty!" %>
<% end %>
```

You can also pass html options to the input:

```erb
<%= invisible_captcha :subtitle, :topic, id: "your_id", class: "your_class" %>
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
$ bundle exec appraisal install
$ bundle exec appraisal rspec
```

### Demo

Start a sample Rails app ([source code](spec/dummy)) with `InvisibleCaptcha` integrated:

```
$ bundle exec rake web # PORT=4000 (default: 3000)
```

## License

Copyright (c) Marc Anguera. Invisible Captcha is released under the [MIT](LICENSE) License.
