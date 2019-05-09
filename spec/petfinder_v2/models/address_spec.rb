require 'spec_helper'

RSpec.describe PetfinderV2::Models::Address do
  let(:address_data) do
    {
      'address1' => 'Test address 1',
      'address2' => 'Test address 2',
      'city' => 'Jersey City',
      'state' => 'New Jersey',
      'postcode' => '07097',
      'country' => 'US'
    }
  end
  describe 'instance methods' do
    let(:model) { described_class.new(address_data) }
    it 'should have an address1' do
      expect(model.address1).to_not be_nil
    end
    it 'shoud have an address2' do
      expect(model.address2).to_not be_nil
    end
    it 'should have a city' do
      expect(model.city).to_not be_nil
    end
    it 'should have a state' do
      expect(model.state).to_not be_nil
    end
    it 'should have a postcode' do
      expect(model.postcode).to_not be_nil
    end
    it 'should have a country' do
      expect(model.country).to_not be_nil
    end
  end
end
