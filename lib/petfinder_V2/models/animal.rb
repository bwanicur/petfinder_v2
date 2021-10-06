require_relative 'pagination'
require_relative 'contact'
require_relative 'photos'

module PetfinderV2
  module Models
    class Breed
      attr_reader :primary, :secondary, :mixed, :unknown
      def initialize(data)
        @primary = data['primary']
        @secondary = data['secondary']
        @mixed = data['mixed']
        @unknown = data['unknown']
      end
    end

    class Animal
      NESTED_ATTRIBUTE_ATTS = %w[
        declawed
        house_trained
        shots_current
        spayed_neutered
        special_needs
      ].freeze

      def self.process_collection(data)
        {
          pagination: PetfinderV2::Models::Pagination.new(data['pagination']),
          animals: data['animals'].map { |d| new(d) }
        }
      end

      attr_reader :age,
                  :coat,
                  :contact,
                  :description,
                  :gender,
                  :id,
                  :name,
                  :organization_id,
                  :species,
                  :size,
                  :status,
                  :type

      def initialize(data)
        @data = data
        @age = data['age']
        @coat = data['coat']
        @contact = data['contact']
        @description = data['description']
        @gender = data['gender']
        @id = data['id']
        @name = data['name']
        @organization_id = data['organization_id']
        @photos = data['photos']
        @species = data['species']
        @size = data['size']
        @status = data['status']
        @type = data['type']
      end

      NESTED_ATTRIBUTE_ATTS.each do |att|
        define_method(att.to_sym) { @data['attributes'][att] }
      end

      def full_response
        @data
      end

      def breeds
        Breed.new(@data['breeds'])
      end

      def contact
        Contact.new(@data['contact'])
      end

      def photos
        Photos.process_collection(@data['photos'])
      end

      def link
        @data['_links']['self']['href']
      end

      def organization_link
        @data['_links']['organization']['href']
      end
    end
  end
end
