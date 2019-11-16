# Changelog

All notable changes to this project will be documented in this file.

## Next

- Remove Ruby 2.2 and Rails 3.2 support
- Add Instrumentation event (#62)

## [0.13.0]

- Add support for the Content Security Policy nonce (#61)
- Freeze all strings (#60)

## [0.12.2]

- Allow new timestamp to be set during `on_timestamp_spam` callback (#53)

## [0.12.1]

- Clear timestamp stored in `session[:invisible_captcha_timestamp]` (#50)
- Rails 6 support

## [0.12.0]

- Honeypot input with autocomplete="off" by default (#42)

## [0.11.0]

- Improve logging (#40, #41)
- Official Rails 5.2 support
- Drop Ruby 2.1 from CI

## [0.10.0]

- New timestamp on each request to avoid stale timestamps (#24)
- Allow to inject styles manually anywhere in the layout (#27)
- Allow to change threshold per action
- Dynamic css strategy to hide the honeypot
- Remove Ruby 1.9 support
- Random default honeypots on each restart
- Allow to pass html_options to honeypot input (#28)
- Improvements on demo application and tests
- Better strong parameters interaction (#30, #33)

## [0.9.3]

- Rails 5.1 support (#29)
- Modernize CI Rubies

## [0.9.2]

- Rails 5.0 official support (#23)
- Travis CI matrix improvements

## [0.9.1]

- Add option (`timestamp_enabled`) to disable timestamp check (#22)

## [0.9.0]

- Remove model style validations (#14)
- Consider as spam if timestamp not in session (#11)
- Allow to define a different threshold per action (#8)
- Appraisals integration (#8)
- CI improvements: use new Travis infrastructure (#8)

## [0.8.2]

- Default timestamp action redirects to back (#19)
- Stores timestamps as string in session (#17)

## [0.8.1]

- Time-sensitive form submissions (#7)
- I18n integration (#13)

## [0.8.0]

- Better Rails integration with `ActiveSupport.on_load` callbacks (#5)
- Allow to override settings via the view helper (#5)

## [0.7.0]

- Revamped code base to allow more customizations (#2)
- Added basic specs (#2)
- Travis integration (#2)
- Demo app (#2)

## [0.6.5]

- Stop using Jeweler

## [0.6.4]

- Docs! (#1)

## [0.6.3]

- Internal re-naming

## [0.6.2]

- Fix gem initialization

## [0.6.0]

- Allow to configure via `InvisibleCaptcha.setup` block

## [0.5.0]

- First version of controller filters

[0.13.0]: https://github.com/markets/invisible_captcha/compare/v0.12.2...v0.13.0
[0.12.2]: https://github.com/markets/invisible_captcha/compare/v0.12.1...v0.12.2
[0.12.1]: https://github.com/markets/invisible_captcha/compare/v0.12.0...v0.12.1
[0.12.0]: https://github.com/markets/invisible_captcha/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/markets/invisible_captcha/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/markets/invisible_captcha/compare/v0.9.3...v0.10.0
[0.9.3]: https://github.com/markets/invisible_captcha/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/markets/invisible_captcha/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/markets/invisible_captcha/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/markets/invisible_captcha/compare/v0.8.2...v0.9.0
[0.8.2]: https://github.com/markets/invisible_captcha/compare/v0.8.1...v0.8.2
[0.8.1]: https://github.com/markets/invisible_captcha/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/markets/invisible_captcha/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/markets/invisible_captcha/compare/v0.6.5...v0.7.0
[0.6.5]: https://github.com/markets/invisible_captcha/compare/v0.6.4...v0.6.5
[0.6.4]: https://github.com/markets/invisible_captcha/compare/v0.6.3...v0.6.4
[0.6.3]: https://github.com/markets/invisible_captcha/compare/v0.6.2...v0.6.3
[0.6.2]: https://github.com/markets/invisible_captcha/compare/v0.6.0...v0.6.2
[0.6.0]: https://github.com/markets/invisible_captcha/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/markets/invisible_captcha/compare/v0.4.1...v0.5.0
