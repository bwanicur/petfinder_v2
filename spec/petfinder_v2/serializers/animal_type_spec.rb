require 'spec_helper'

RSpec.describe PetfinderV2::Serializers::AnimalType do
  let(:full_response) do
    {
      'types' => [
        {
          'name' => 'Rabbit',
          'coats' => %w[
            Short
            Long
          ],
          'colors' => [
            'Agouti',
            'Black',
            'Blue / Gray',
            'Brown / Chocolate',
            'Cream',
            'Lilac',
            'Orange / Red',
            'Sable',
            'Silver Marten',
            'Tan',
            'Tortoiseshell',
            'White'
          ],
          'genders' => %w[
            Male
            Female
          ],
          '_links' => {
            'self' => {
              'href' => '/v2/types/rabbit'
            },
            'breeds' => {
              'href' => '/v2/types/rabbit/breeds'
            }
          }
        },
        {
          'name' => 'Bird',
          'coats' => [],
          'colors' => [
            'Black',
            'Blue',
            'Brown',
            'Buff',
            'Gray',
            'Green',
            'Olive',
            'Orange',
            'Pink',
            'Purple / Violet',
            'Red',
            'Rust / Rufous',
            'Tan',
            'White',
            'Yellow'
          ],
          'genders' => %w[
            Male
            Female
            Unknown
          ],
          '_links' => {
            'self' => {
              'href' => '/v2/types/bird'
            },
            'breeds' => {
              'href' => '/v2/types/bird/breeds'
            }
          }
        }
      ]
    }
  end

  let(:animal_type_response) { full_response['types'].first }

  describe 'self.process_collection' do
    it 'should return an array of animal types' do
      res = described_class.process_collection(full_response)
      expect(res).to be_a(Array)
      expect(res.count).to eq(2)
    end
  end

  describe 'instance methods' do
    let(:animal_type) { described_class.new(animal_type_response) }

    it 'should have a name' do
      expect(animal_type.name).to be
    end

    it 'should have a collection of colors' do
      expect(animal_type.colors).to be_a(Array)
      expect(animal_type.colors.size).to eq(12)
    end

    it 'should have self link' do
      expect(animal_type.link).to eq('/v2/types/rabbit')
    end

    it 'should have a breeds link' do
      expect(animal_type.breeds_link).to eq('/v2/types/rabbit/breeds')
    end
  end
end
