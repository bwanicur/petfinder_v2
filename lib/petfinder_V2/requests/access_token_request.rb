require 'faraday'

module PetfinderV2
  module Requests
    class AccessTokenRequest
      URL = 'https://api.petfinder.com/v2/oauth2/token'.freeze

      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
        @conn = Faraday.new
      end

      def get_access_token
        @conn.post URL,
                   client_id: @client_id,
                   client_secret: @client_secret,
                   grant_type: 'client_credentials'
      end
    end
  end
end
