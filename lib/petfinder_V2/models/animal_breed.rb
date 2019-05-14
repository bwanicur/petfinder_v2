module PetfinderV2
  module Models
    class AnimalBreed
      attr_accessor :name, :type_link

      def self.process_collection(data)
        data['breeds'].map { |b| new(b) }
      end

      def initialize(data)
        @name = data['name']
        @type_link = data['_links']['type']['href']
      end
    end
  end
end
