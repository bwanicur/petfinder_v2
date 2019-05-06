require_relative 'pagination'
require_relative 'contact'

module PetfinderV2
  module Models
    class Breed
      ATTS = %w[
        primary
        secondary
        mixed
        unknown
      ].freeze

      def initialize(data)
        @data = data
      end

      ATTS.each do |att|
        define_method(att.to_sym) { @data[att] }
      end
    end

    class Animal
      BASIC_ATTS = %w[
        age
        coat
        contact
        description
        gender
        id
        name
        organization_id
        photos
        species
        size
        status
        type
      ].freeze

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

      def initialize(data)
        @data = data
      end

      BASIC_ATTS.each do |att|
        define_method(att.to_sym) { @data[att] }
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

      def link
        @data['_links']['self']['href']
      end

      def organization_link
        @data['_links']['organization']['href']
      end
    end
  end
end
