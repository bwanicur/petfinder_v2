require 'faraday'
require 'json'
require_relative '../services/options_validator'
require_relative './access_token_request'
require_relative '../models/access_token'

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

      def initialize
        @conn = Faraday.new(BASE_URL)
      end

      def get(path, opts = {})
        validate_options!(opts)
        set_connection_headers
        set_connection_get_params(opts)
        @conn.get(path)
      end

      private

      def validate_options!(opts)
        errors = PetfinderV2::Services::OptionsValidator.new(opts).run
        unless errors.empty?
          raise(PetfinderV2::InvalidRequestOptionsError, errors.join("\n"))
        end
      end

      def set_connection_headers
        @conn.headers['Content-Type'] = 'application/json'
        @conn.headers['Authorization'] = "Bearer #{get_token.token}"
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

      def get_token
        access_token_expired? ? refresh_access_token : @@access_token
      end

      def access_token_expired?
        return true if @@access_token.nil?

        @@access_token.expires_at < Time.now
      end

      def refresh_access_token
        res = Requests::AccessTokenRequest.new(
          @client_id,
          @client_secret
        ).get_access_token
        Models::AccessToken.new(res)
      end
    end
  end
end
