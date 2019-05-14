require 'spec_helper'

RSpec.describe PetfinderV2::Services::OrganizationOptionsValidator do
  let(:valid_opts) do
    {
      state: 'CA',
      name: 'Second Chance Dog Rescue',
      query: 'San Diego CA 92101 Second Chance Dog Rescue'
    }
  end

  describe '#run' do
    it 'should return an empty array if all options are valid' do
      expect(described_class.new(valid_opts).run).to eq([])
    end

    it 'should return an error when a wrong value type is used' do
      invalid_val_opts = { state: 1001 }
      res = described_class.new(invalid_val_opts).run
      expect(res.first.match(/State/)).to be_truthy
    end
  end
end
