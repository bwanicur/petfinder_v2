require 'spec_helper'

RSpec.describe PetfinderV2::Models::AnimalBreed do
  let(:full_response) do
    {
      'breeds' => [
        {
          'name' => 'Affenpinscher',
          '_links' => {
            'type' => {
              'href' => '/v2/types/dog'
            }
          }
        },
        {
          'name' => 'Afghan Hound',
          '_links' => {
            'type' => {
              'href' => '/v2/types/dog'
            }
          }
        },
        {
          'name' => 'Airedale Terrier',
          '_links' => {
            'type' => {
              'href' => '/v2/types/dog'
            }
          }
        }
      ]
    }
  end

  describe 'self.process_collection' do
    it 'should return an array of AnimalBreed objects' do
      res = described_class.process_collection(full_response)
      expect(res).to be_a(Array)
      expect(res.size).to eq(3)
      expect(res.first).to be_a(PetfinderV2::Models::AnimalBreed)
    end
  end

  describe 'instance methods' do
    let(:animal_breed) { described_class.new(full_response['breeds'].first) }

    it 'should have a name' do
      expect(animal_breed.name).to eq('Affenpinscher')
    end

    it 'should have a type_link' do
      expect(animal_breed.type_link).to eq('/v2/types/dog')
    end
  end
end
