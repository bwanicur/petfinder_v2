require 'spec_helper'

RSpec.describe PetfinderV2::Models::Pagination do
  let(:pagination_response) do
    {
      'count_per_page' => 1,
      'total_count' => 320,
      'current_page' => 1,
      'total_pages' => 320,
      '_links' => {}
    }
  end

  describe 'instance methods' do
    let(:pagination_model) { described_class.new(pagination_response) }

    it 'should have a count_per_page' do
      expect(pagination_model.count_per_page).to eq(1)
    end

    it 'should have a current_page' do
      expect(pagination_model.current_page).to eq(1)
    end

    it 'should have a total_count' do
      expect(pagination_model.total_count).to eq(320)
    end

    it 'should have a total_pages' do
      expect(pagination_model.total_pages).to eq(320)
    end
  end
end
