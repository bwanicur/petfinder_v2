module PetfinderV2
  module Serializers
    class Photos
      def self.process_collection(collection)
        collection.inject([]) { |mem, photos_hash| mem << new(photos_hash) }
      end

      attr_reader :small, :medium, :large, :full
      def initialize(data)
        @small = data['small']
        @medium = data['medium']
        @large = data['large']
        @full = data['full']
      end
    end
  end
end
