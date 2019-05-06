require 'spec_helper'

RSpec.describe PetfinderV2::Models::Animal do
  let(:full_response) do
    {
      'animals' => [
        {
          'id' => 124,
          'organization_id' => 'NJ333',
          'url' => 'https://www.petfinder.com/cat/nebula-124/nj/jersey-city/nj333-petfinder-test-account/?referrer_id=d7e3700b-2e07-11e9-b3f3-0800275f82b1',
          'type' => 'Cat',
          'species' => 'Cat',
          'breeds' => {
            'primary' => 'American Shorthair',
            'secondary' => nil,
            'mixed' => false,
            'unknown' => false
          },
          'colors' => {
            'primary' => 'Tortoiseshell',
            'secondary' => nil,
            'tertiary' => nil
          },
          'age' => 'Young',
          'gender' => 'Female',
          'size' => 'Medium',
          'coat' => 'Short',
          'name' => 'Nebula',
          'description' => 'Nebula is a shorthaired, shy cat. She is very affectionate once she warms up to you.',
          'photos' => [
            {
              'small' => 'http://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=100',
              'medium' => 'http://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=300',
              'large' => 'http://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=600',
              'full' => 'http://photos.petfinder.com/photos/pets/124/1/?bust=1546042081'
            }
          ],
          'status' => 'adoptable',
          'attributes' => {
            'spayed_neutered' => true,
            'house_trained' => true,
            'declawed' => false,
            'special_needs' => false,
            'shots_current' => true
          },
          'environment' => {
            'children' => false,
            'dogs' => true,
            'cats' => true
          },
          'tags' => %w[
            Cute
            Intelligent
            Playful
            Happy
            Affectionate
          ],
          'contact' => {
            'email' => 'petfindertechsupport@gmail.com',
            'phone' => '555-555-5555',
            'address' => {
              'address1' => nil,
              'address2' => nil,
              'city' => 'Jersey City',
              'state' => 'NJ',
              'postcode' => '07097',
              'country' => 'US'
            }
          },
          'published_at' => '2018-09-04T14:49:09+0000',
          '_links' => {
            'self' => {
              'href' => '/v2/animals/124'
            },
            'type' => {
              'href' => '/v2/types/cat'
            },
            'organization' => {
              'href' => '/v2/organizations/nj333'
            }
          }
        }
      ],
      'pagination' => {
        'count_per_page' => 1,
        'total_count' => 320,
        'current_page' => 1,
        'total_pages' => 320,
        '_links' => {}
      }
    }
  end

  let(:animal_response) do
    full_response['animals'].first
  end

  describe 'self.process_collection' do
    it 'should return a collection of Animal models and a Pagination object' do
      res = described_class.process_collection(full_response)
      expect(res[:animals]).to be_a(Array)
      expect(res[:animals].size).to eq(1)
      expect(res[:pagination]).to be_a(PetfinderV2::Models::Pagination)
      expect(res[:pagination].count_per_page).to eq(1)
      expect(res[:pagination].current_page).to eq(1)
      expect(res[:pagination].total_count).to eq(320)
      expect(res[:pagination].total_pages).to eq(320)
    end
  end

  context 'instance methods' do
    let(:model) { described_class.new(animal_response) }

    describe 'basic_atts' do
      it 'should return values for basic attributes' do
        expect(model.age).to eq('Young')
        expect(model.coat).to eq('Short')
        expect(model.description).to eq('Nebula is a shorthaired, shy cat. She is very affectionate once she warms up to you.')
        expect(model.name).to eq('Nebula')
        expect(model.organization_id).to eq('NJ333')
        expect(model.size).to eq('Medium')
        expect(model.status).to eq('adoptable')
        expect(model.type).to eq('Cat')
      end
    end

    describe 'nested atts' do
      it 'should return values for nested attributes' do
        expect(model.declawed).to eq(false)
        expect(model.house_trained).to eq(true)
        expect(model.shots_current).to eq(true)
        expect(model.spayed_neutered).to eq(true)
        expect(model.special_needs).to eq(false)
      end
    end

    describe 'custom atts' do
      it 'should return a breeds object' do
        breeds_obj = model.breeds
        expect(breeds_obj).to be_a(PetfinderV2::Models::Breed)
        expect(breeds_obj.primary).to eq('American Shorthair')
        expect(breeds_obj.secondary).to be_nil
        expect(breeds_obj.mixed).to eq(false)
        expect(breeds_obj.unknown).to eq(false)
      end

      it 'should return a contact object' do
        contact = model.contact
        expect(contact).to be_a(PetfinderV2::Models::Contact)
        expect(contact.address).to be_a(PetfinderV2::Models::Address)
        expect(contact.email).to eq('petfindertechsupport@gmail.com')
        expect(contact.phone).to eq('555-555-5555')
        expect(contact.address.city).to eq('Jersey City')
        expect(contact.address.state).to eq('NJ')
      end

      it 'should return the full response' do
        expect(model.full_response).to eq(animal_response)
      end

      it 'should return a link to the animal' do
        expect(model.link).to eq('/v2/animals/124')
      end

      it 'should return a link to the organization' do
        expect(model.organization_link).to eq('/v2/organizations/nj333')
      end
    end
  end
end
