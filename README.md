# PetfinderV2

Wrapper for the <a href="https://www.petfinder.com/developers/v2/docs/" target="_blank">Petfinder V2 API</a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'petfinder_V2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install petfinder_V2

## Usage

```ruby
# configure the client globally
PetfinderV2::Config.set(CLIENT_ID, CLIENT_SECRET)
client = PetfinderV2::Client.new

# or per client instance
client = PetfinderV2::Client.new(CLIENT_ID, CLIENT_SECRET)

options = {
  age: [ 'adult', 'senior' ],
  gender: 'female',
  size: [ 'medium', 'large' ]
}
result = client.search_animals(options)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/petfinder_V2.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
