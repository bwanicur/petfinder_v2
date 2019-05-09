require 'spec_helper'

RSpec.describe PetfinderV2::Models::Organization do
  let(:full_response) do
    {
      'organizations' => [
        {
          'id' => 'NJ333',
          'name' => 'NJ333 - Petfinder Test Account',
          'email' => 'no-reply@petfinder.com',
          'phone' => '555-555-5555',
          'address' => {
            'address1' => 'Test address 1',
            'address2' => 'Test address 2',
            'city' => 'Jersey City',
            'state' => 'NJ',
            'postcode' => '07097',
            'country' => 'US'
          },
          'hours' => {
            'monday' => nil,
            'tuesday' => nil,
            'wednesday' => nil,
            'thursday' => nil,
            'friday' => nil,
            'saturday' => nil,
            'sunday' => nil
          },
          'url' => 'https://www.petfinder.com/member/us/nj/jersey-city/nj333-petfinder-test-account/?referrer_id=d7e3700b-2e07-11e9-b3f3-0800275f82b1',
          'website' => 'http://test.com',
          'mission_statement' => nil,
          'adoption' => {
            'policy' => nil,
            'url' => nil
          },
          'social_media' => {
            'facebook' => nil,
            'twitter' => nil,
            'youtube' => nil,
            'instagram' => nil,
            'pinterest' => nil
          },
          'photos' => [
            {
              'small' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=100',
              'medium' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=300',
              'large' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=600',
              'full' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081'
            }
          ],
          '_links' => {
            'self' => {
              'href' => '/v2/organizations/nj333'
            },
            'animals' => {
              'href' => '/v2/animals?organization=nj333'
            }
          }
        }
      ],
      'pagination' => {
        'count_per_page' => 20,
        'total_count' => 1,
        'current_page' => 1,
        'total_pages' => 2,
        '_links' => {
          'next' => {
            'href' => '/v2/organizations?page=2'
          }
        }
      }
    }
  end

  let(:organization_response) { full_response['organizations'].first }

  describe 'self.process_collection' do
    it 'should return a collection of Organizations and a Pagination object' do
      res = described_class.process_collection(full_response)
      expect(res[:pagination]).to be_a(PetfinderV2::Models::Pagination)
      expect(res[:pagination].count_per_page).to eq(20)
      expect(res[:organizations]).to be_a(Array)
      expect(res[:organizations].size).to eq(1)
    end
  end

  describe 'instance methods' do
    let(:model) { described_class.new(organization_response) }

    it 'should have an id' do
      expect(model.id).to_not be_nil
    end

    it 'should have a name' do
      expect(model.name).to eq('NJ333 - Petfinder Test Account')
    end

    it 'should have an email' do
      expect(model.email).to_not be_nil
    end

    it 'should have a url' do
      expect(model.url).to_not be_nil
    end

    it 'should have a website' do
      expect(model.website).to_not be_nil
    end

    it 'should have an address object' do
      expect(model.address).to be_a(PetfinderV2::Models::Address)
    end

    it 'should have an hours object' do
      expect(model.hours).to be_a(PetfinderV2::Models::OrgHours)
    end

    it 'should have an social media object' do
      expect(model.social_media).to be_a(PetfinderV2::Models::SocialMedia)
    end
  end
end
