require 'faraday'

module PetfinderV2
  module Requests
    class Request
      @@access_token = nil

      BASE_URL = 'https://api.petfinder.com/v2'.freeze

      COLLECTION_OPTS = %i[
        age
        breed
        coat
        color
        gender
        organization
        size
      ].freeze

      SINGLE_OPTS = %i[
        distance
        limit
        location
        name
        page
        sort
        status
        type
      ].freeze

      def self.reset_access_token!
        @@access_token = nil
      end

      def initialize(access_token)
        @access_token = access_token
        @conn = Faraday.new(BASE_URL)
      end

      def get(path, opts = {})
        set_connection_headers
        set_connection_get_params(opts)
        @conn.get(path)
      end

      private

      def set_connection_headers
        @conn.headers['Content-Type'] = 'application/json'
        @conn.headers['Authorization'] = "Bearer #{@access_token}"
      end

      def set_connection_get_params(opts)
        SINGLE_OPTS.each do |key|
          @conn.params[key.to_s] = opts[key].to_s if opts[key]
        end
        COLLECTION_OPTS.each do |key|
          @conn.params[key.to_s] = collection_opts(opts[key]) if opts[key]
        end
      end

      def collection_opts(collection)
        if collection.respond_to?(:each)
          collection.join(',')
        else
          collection.to_s
        end
      end
    end
  end
end
