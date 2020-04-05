# PryDiffRoutes ![build](https://github.com/styd/pry-diff-routes/workflows/build/badge.svg?branch=master)

> Inspect routes changes in Rails console.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pry-diff-routes', group: :development
```

## Usage
### Flags

A route is considered the same route if it maintains its verb (http method, e.g. `GET`, `POST`,
etc.) and uri path. When its other properties are changed, we call it a modified route.

#### `-R` or `--removed`

Show removed routes only.

#### `-M` or `--modified`

Show modified routes only.

#### `-N` or `--new`

Show new routes only.

#### `-S` or `--save`

Make current routes as the basis for changes.

You can combine `-R`, `-M`, and `-N` together, but not `-S`.

### Demo Screenshot

![pry-diff-routes demo screenshot](/images/demo-screenshot.gif)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/styd/pry-diff-routes.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[code of conduct](https://github.com/styd/pry-diff-routes/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pry::Diff::Routes project's codebases, issue trackers, chat rooms
and mailing lists is expected to follow the
[code of conduct](https://github.com/styd/pry-diff-routes/blob/master/CODE_OF_CONDUCT.md).
