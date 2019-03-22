# ActiveRecord::FindOnly

Provides the `#find_only` and `#find_only!` methods for querying ActiveRecord objects.

`#find_only` - returns the only record that meets the criteria. If no records match
the criteria, `nil` is returned. Raises `TooManyRecords` if more than one
records matches the criteria.

`#find_only!` - returns the only record that meets the criteria. If no records match
the criteria, `RecordNotFound` is raised. Raises `TooManyRecords` if more than
one records matches the criteria.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-find_only'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-find_only

## Usage

See the spec files for example usage.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
