require 'spec_helper'

RSpec.describe PetfinderV2::Serializers::Contact do
  let(:contact_response) do
    {
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
    }
  end

  describe 'instance methods' do
    let(:contact) { described_class.new(contact_response) }

    it 'should return an email' do
      expect(contact.email).to eq('petfindertechsupport@gmail.com')
    end

    it 'should return a phone number' do
      expect(contact.phone).to eq('555-555-5555')
    end

    it 'should return an address object' do
      expect(contact.address.class).to eq(PetfinderV2::Serializers::Address)
    end
  end
end
