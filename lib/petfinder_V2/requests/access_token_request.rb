require 'faraday'
require 'json'

module PetfinderV2
  module Requests
    class AccessTokenRequest
      URL = 'https://api.petfinder.com/v2/oauth2/token'

      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
        @conn = Faraday.new
      end

      def get_access_token
        res = @conn.post URL, {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: 'client_credentials'
        }
        JSON.parse(res.body)
      end
    end
  end
end
