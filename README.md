# ActiveRecord::Only

Provides the `#only` and `#only!` methods for querying ActiveRecord objects.

`#only` - returns the only record that meets the criteria. If no records match
the criteria, `nil` is returned. Raises `TooManyRecords` if more than one
records matches the criteria.

`#only!` - returns the only record that meets the criteria. If no records match
the criteria, `RecordNotFound` is raised. Raises `TooManyRecords` if more than
one records matches the criteria.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-only'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-only

## Usage

See the spec files for example usage.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
