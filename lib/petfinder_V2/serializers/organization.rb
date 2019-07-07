require_relative 'address'
require_relative 'photos'
require_relative 'pagination'

module PetfinderV2
  module Serializers
    class SocialMedia
      attr_reader :facebook, :twitter, :youtube, :instagram, :pinterest
      def initialize(data)
        @facebook = data['facebook']
        @twitter = data['twitter']
        @youtube = data['youtube']
        @instagram = data['instagram']
        @pinterest = data['pinterest']
      end
    end

    class OrgHours
      attr_reader :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
      def initialize(data)
        @monday = data['monday']
        @tuesday = data['tuesday']
        @wednesday = data['wednesday']
        @thursday = data['thursday']
        @friday = data['friday']
        @saturday = data['saturday']
        @sunday = data['sunday']
      end
    end

    class Organization
      def self.process_collection(data)
        {
          pagination: PetfinderV2::Serializers::Pagination.new(data['pagination']),
          organizations: data['organizations'].map { |o| new(o) }
        }
      end

      attr_reader :id,
                  :name,
                  :email,
                  :phone,
                  :url,
                  :website,
                  :mission_statement,
                  :adoption_policy,
                  :adoption_url,
                  :link,
                  :animals_link

      def initialize(data)
        @data = data
        @id = data['id']
        @name = data['name']
        @email = data['email']
        @phone = data['phone']
        @url = data['url']
        @website = data['website']
        @mission_statement = data['mission_statement']
        @adoption_policy = data['adoption']['policy']
        @adoption_url = data['adoption']['url']
        @link = data['_links']['self']['href']
        @animals_link = data['_links']['animals']['href']
      end

      def full_response
        @data
      end

      def address
        Address.new(@data['address'])
      end

      def hours
        OrgHours.new(@data['hours'])
      end

      def social_media
        SocialMedia.new(@data['social_media'])
      end
    end
  end
end
