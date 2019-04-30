require 'faraday'
require 'json'
require_relative '../services/options_validator'

module PetfinderV2
  module Requests
    class Request
      BASE_URL = 'https://api.petfinder.com/v2'

      COLLECTION_OPTS = [
        :age,
        :breed,
        :coat,
        :color,
        :gender,
        :organization,
        :size
      ]

      SINGLE_OPTS = [
        :distance,
        :limit,
        :location,
        :name,
        :page,
        :sort,
        :status,
        :type
      ]

      def initialize(access_token)
        @access_token = access_token
        @conn = Faraday.new(BASE_URL)
      end

      def get(path, opts = {})
        validate_options!(opts)
        set_connection_headers!(opts)
        set_connection_get_params!(opts)
        @conn.get(path)
      end

      private

      def validate_options!(opts)
        errors = PetfinderV2::Service::OptionsValidator.new(opts).run
        if !errors.empty?
          msg = errors.join("\n")
          raise PetfinderV2::InvalidRequestOptionsError.new(msg)
        end
      end

      def set_connection_headers!(opts)
        @conn.headers['Content-Type'] = 'application/json'
        @conn.headers['Authorization'] = "Bearer #{@access_token}"
      end

      def set_connection_get_params!(opts)
        SINGLE_OPTS.each do |key|
          @conn.params[key.to_s] = opts[key].to_s if opts[key]
        end
        COLLECTION_OPTS.each do |key|
          @conn.params[key.to_s] = collection_opts(opts[key]) if opts[key]
        end
      end

      def collection_opts(collection)
        if collection.responds_to?(:each)
          collection.join(',')
        else
          collection.to_s
        end
      end
    end
  end
end
