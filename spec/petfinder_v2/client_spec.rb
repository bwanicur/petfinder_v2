require 'spec_helper'

RSpec.describe PetfinderV2::Client do
  let(:client) { described_class.new(CLIENT_ID, CLIENT_SECRET) }
  before { described_class.class_variable_set(:@@access_token, nil) }

  describe 'self.reset_access_token!' do
    it 'should reset the access token from the PetfinderV2 OAuth' do
      described_class.class_variable_set(:@@access_token, 'not-nil')
      described_class.reset_access_token!
      expect(described_class.class_variable_get(:@@access_token)).to be_nil
    end
  end

  describe '#search_animals' do
    it 'should return a collection using the limit' do
      VCR.use_cassette('limit-five') do
        res = client.search_animals(limit: 5)
        expect(res[:animals].count).to eq(5)
      end
    end

    context 'scoped by type' do
      it 'should return birds' do
        VCR.use_cassette('birds-only') do
          res = client.search_animals(type: 'bird')
          expect(res[:animals].map(&:type).uniq.first).to eq('Bird')
        end
      end
      it 'should return dogs' do
        VCR.use_cassette('dogs-only') do
          res = client.search_animals(type: 'dog')
          expect(res[:animals].map(&:type).uniq.first).to eq('Dog')
        end
      end
      it 'should return cats' do
        VCR.use_cassette('cats-only') do
          res = client.search_animals(type: 'cat')
          expect(res[:animals].map(&:type).uniq.first).to eq('Cat')
        end
      end
    end

    context 'scoped by size' do
      it 'should return small animals' do
        VCR.use_cassette('small-only') do
          res = client.search_animals(size: 'small')
          expect(res[:animals].map(&:size).uniq.first).to eq('Small')
        end
      end
      it 'should return medium and large animals' do
        VCR.use_cassette('medium-and-large-only') do
          res = client.search_animals(size: %w[medium large])
          expect(res[:animals].map(&:size).uniq.sort).to eq(%w[Large Medium])
        end
      end
    end

    context 'scoped by gender' do
      it 'should return females only' do
        VCR.use_cassette('females-only') do
          res = client.search_animals(gender: 'female')
          expect(res[:animals].map(&:gender).uniq.first).to eq('Female')
        end
      end
      it 'should return unkowns only' do
        VCR.use_cassette('unknowns-only') do
          res = client.search_animals(gender: 'unknown')
          expect(res[:animals].map(&:gender).uniq.first).to eq('Unknown')
        end
      end
      it 'should return females and males only' do
        VCR.use_cassette('females-and-males-only') do
          res = client.search_animals(gender: %w[female male])
          expect(res[:animals].map(&:gender).uniq.sort).to eq(%w[Female Male])
        end
      end
    end

    context 'scoped by age' do
      it 'should return seniors only' do
        VCR.use_cassette('seniors-only') do
          res = client.search_animals(age: 'senior')
          expect(res[:animals].map(&:age).uniq.first).to eq('Senior')
        end
      end
      it 'should return adults and seniors only' do
        VCR.use_cassette('adults-and-seniors-only') do
          res = client.search_animals(age: %w[adult senior])
          expect(res[:animals].map(&:age).uniq.sort).to eq(%w[Adult Senior])
        end
      end
    end

    context 'scoped by coat' do
      it 'should return wirey only' do
        VCR.use_cassette('wirey-coat-only') do
          res = client.search_animals(coat: 'wire')
          expect(res[:animals].map(&:coat).uniq.first).to eq('Wire')
        end
      end
      it 'should return medium and short only' do
        VCR.use_cassette('medium-and-short-coat-only') do
          res = client.search_animals(coat: %w[medium short])
          expect(res[:animals].map(&:coat).uniq.sort).to eq(%w[Medium Short])
        end
      end
    end

    context 'scoped by status' do
      it 'should return adoptables only' do
        VCR.use_cassette('adoptable-only') do
          res = client.search_animals(status: 'adoptable')
          expect(res[:animals].map(&:status).uniq.first).to eq('adoptable')
        end
      end
      it 'should return found only' do
        VCR.use_cassette('found-only') do
          res = client.search_animals(status: 'found')
          expect(res[:animals].map(&:status).uniq.first).to eq('found')
        end
      end
    end

    context 'errors' do
      it 'should raise an exception if we have invalid options' do
        expect { client.search_animals(age: 'this is wrong') }.to raise_error(PetfinderV2::InvalidRequestOptionsError)
      end

      it 'should capture an invalid CLIENT_ID / CLIENT_SECRET request inside an exception' do
        client = described_class.new('fake', 'fake')
        VCR.use_cassette('invalid-pf-credntials-request') do
          expect { client.search_animals(type: 'dog') }.to raise_error(PetfinderV2::Error)
        end
      end
    end
  end

  describe '#get_animal' do
    it 'should return a single animal object' do
      test_animal_id = 50697090
      VCR.use_cassette('get-animal') do
        res = client.get_animal(test_animal_id)
        expect(res).to be_a(PetfinderV2::Models::Animal)
        expect(res.name).to eq('Ruby')
        expect(res.age).to eq('Senior')
      end
    end

    it 'should raise an exception if the id is not found' do
      VCR.use_cassette('no-animal-404') do
        expect { client.get_animal(124) }.to raise_error(PetfinderV2::Error)
      end
    end
  end

  describe '#search_organizations' do
    it 'should search organizations by name' do
      VCR.use_cassette('search-organizations-by-name') do
        res = client.search_organizations(name: 'Second Chance Dog Rescue')
        expect(res[:organizations].size).to eq(4)
        expect(res[:pagination].total_pages).to eq(1)
        expect(res[:pagination].total_count).to eq(4)
      end
    end

    it 'should  search by location' do
      VCR.use_cassette('search-organizations-by-location') do
        res = client.search_organizations(location: '92101', distance: 5)
        expect(res[:organizations].count).to eq(20)
      end
    end
  end

  describe 'get organization' do
    it 'should return an organzation' do
      VCR.use_cassette('get-organization') do
        test_org_id = "LA392"
        res = client.get_organization(test_org_id)
        expect(res).to be_a(PetfinderV2::Models::Organization)
        expect(res.id).to eq(test_org_id)
      end
    end
  end

  describe 'get animal types' do
    it 'should return a collection of animal types' do
      VCR.use_cassette('get-animal-types') do
        res = client.get_animal_types
        expect(res).to be_a(Array)
        expect(res.count).to eq(8)
      end
    end
  end

  describe 'get single animal type' do
    it 'should return the type data for a single kind of animal' do
      VCR.use_cassette('get-animal-type-by-name') do
        res = client.get_animal_type('dog')
        expect(res).to be_a(PetfinderV2::Models::AnimalType)
        expect(res.name).to be
        expect(res.link).to be
        expect(res.breeds_link).to be
      end
    end
  end

  describe 'get animal breeds' do
    it 'should return a collection of animal breeds' do
      VCR.use_cassette('get-dog-breeds') do
        res = client.get_animal_breeds('dog')
        expect(res).to be_a(Array)
        expect(res.first).to be_a(PetfinderV2::Models::AnimalBreed)
        expect(res.size).to eq(275)
      end
    end
  end
end
