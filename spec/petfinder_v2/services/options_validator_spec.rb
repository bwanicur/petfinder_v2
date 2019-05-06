require 'spec_helper'

RSpec.describe PetfinderV2::Services::OptionsValidator do
  let(:valid_opts) do
    {
      age: %w[adult senior],
      gender: 'male',
      coat: %w[short medium],
      breed: ['Staffordshire Bull Terrier', 'Pitbull']
    }
  end

  describe '#run' do
    it 'should return an empty array if all options are valid' do
      expect(described_class.new(valid_opts).run).to eq([])
    end

    it 'should return an array of errors when there are invalid option keys' do
      invalid_opts = { invalid_key: 'somevalue' }
      res = described_class.new(invalid_opts).run
      expect(res).to_not be_empty
      expect(res.first.match(/invalid_key/)).to be_truthy
    end

    it 'should return an error when a wrong value type is used' do
      invalid_val_opts = { breed: 1001 }
      res = described_class.new(invalid_val_opts).run
      expect(res.first.match(/Breed/)).to be_truthy
    end

    it 'should return an array of errors when there are invalid options values' do
      invalid_opts = valid_opts.merge(age: %i[tinypup young])
      res = described_class.new(invalid_opts).run
      expect(res).to_not be_empty
      expect(res.first.match(/tinypup/)).to be_truthy
    end
  end
end
