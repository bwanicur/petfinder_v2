require 'spec_helper'

RSpec.describe PetfinderV2::Models::Photos do
  let(:photos_data) do
    [
      {
        'small' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=100',
        'medium' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=300',
        'large' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081&width=600',
        'full' => 'http://photos.petfinder.com/photos/organizations/124/1/?bust=1546042081'
      }
    ]
  end

  describe 'self.process_collection' do
    it 'should return an array of Photo objects' do
      res = described_class.process_collection(photos_data)
      expect(res).to be_a(Array)
      expect(res.size).to eq(1)
    end
  end

  describe 'instance methods' do
    let(:photo) { described_class.new(photos_data.first) }

    it 'should have a small photo' do
      expect(photo.small).to_not be_nil
    end

    it 'should have a medium photo' do
      expect(photo.medium).to_not be_nil
    end

    it 'should have a large photo' do
      expect(photo.large).to_not be_nil
    end

    it 'should have a full photo' do
      expect(photo.full).to_not be_nil
    end
  end
end
