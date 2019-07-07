# PetfinderV2

Wrapper for the <a href="https://www.petfinder.com/developers/v2/docs/" target="_blank">Petfinder V2 API</a>

## Installation

Add this line to your application's Gemfile-

```ruby
gem 'petfinder_V2'
```

And then execute-

    $ bundle

Or install it yourself as-

    $ gem install petfinder_V2

## Usage

```ruby
# configure the client globally
PetfinderV2::Config.instance.set(client_id: <CLIENT_ID>)
PetfinderV2::Config.instance.set(client_secret: <CLIENT_SECRET>)
client = PetfinderV2::Client.new

# or per client instance
client = PetfinderV2::Client.new(CLIENT_ID, CLIENT_SECRET)

options = {
  age:  [ 'adult' 'senior' ]
  gender:  'female'
  size:  [ 'medium' 'large' ]
}
result = client.search_animals(options)
```

## Methods

- `client.search_animals(options)`
  - options-  <a href="https://www.petfinder.com/developers/v2/docs/#get-animals" target="_blank">Petfinder V2 Docs</a>
  - returns-  collection of `Animal` objects

- `client.get_animal(id)`
  - returns-  `Animal` object

- `client.get_animal_types`
  - returns-  collection of `AnimalType` objects

- `client.get_animal_type(type_name)`
    - `type_name` is a type of animal (e.g 'dog' 'cat' etc...)
    - more documentation <a href="https://www.petfinder.com/developers/v2/docs/#get-animal-types" target="_blank">here</a>
    - returns `AnimalType` object

- `client.get_animal_breeds(type_name)`
  - `type_name` is a type of animal (e.g 'dog' 'cat' etc...)
  - returns-  a collection of `AnimalBreed` objects

- `client.search_organizations(options)`
  - options-  <a href="https://www.petfinder.com/developers/v2/docs/#get-organizations" target="_blank">Petfinder V2 Docs</a>
  - returns-  collection of `Organization` objects

- `client.get_organization(id)`
  - returns-  `Organization` object

## Models
- Animal
  - id
  - name
  - age
  - coat
  - contact
  - description
  - gender
  - organization_id
  - species
  - size
  - status
  - type
  - declawed
  - house_trained
  - shots_current
  - spayed_neutered
  - special_needs
  - link
  - organization_link
  - breeds --> `Breed` object
  - photos --> `Photos` object
  - contact --> `Contact` object

- Breed
  - primary
  - secondary
  - mixed
  - unkown

- AnimalType
  - name
  - colors
  - genders
  - link
  - breeds_link
  
- AnimalBreed (returned from `get_animal_breeds`)
  - name
  - type_link

- Organization  
  - id
  - name
  - email
  - phone
  - url
  - website
  - mission_statement
  - adoption_policy
  - adoption_url
  - link
  - animals_link
  - address --> `Address` object
  - hours --> `OrgHours` object
  - social_media --> `SocialMedia` object
  
- Photos
  - small
  - medium
  - large
  - full

- Pagination
  - count_per_page
  - total_count
  - current_page
  - total_pages
  - links

- Contact
  - phone
  - email
  - address --> `Address` object
  
- Address
  - address1
  - address2
  - city
  - state
  - postcode
  - country
  
## Development

After checking out the repo run `bin/setup` to install dependencies. Then run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine run `bundle exec rake install`. To release a new version update the version number in `version.rb` and then run `bundle exec rake release` which will create a git tag for the version push git commits and tags and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/petfinder_V2.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
