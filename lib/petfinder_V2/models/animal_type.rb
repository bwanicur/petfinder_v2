module PetfinderV2
  module Models
    class AnimalType
      attr_reader :name, :colors, :genders, :link, :breeds_link

      def self.process_collection(data)
        data['types'].map { |d| new(d) }
      end

      def initialize(data)
        @name = data['name']
        @colors = data['colors']
        @genders = data['genders']
        @link = data['_links']['self']['href']
        @breeds_link = data['_links']['breeds']['href']
      end
    end
  end
end
