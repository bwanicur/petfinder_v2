require_relative 'requests/access_token'
require_relative 'requests/access_token_request'
require_relative 'requests/request'
require_relative 'config'

module PetfinderV2
  class Client
    @@access_token = nil

    def initialize(client_id = nil, client_secret = nil)
      @client_id = client_id || Config.instance.read(:client_id)
      @client_secret = client_secret || Config.instance.read(:client_secret)
    end

    def search_animals(opts = {})
      res = Requests::Request.new(get_token).get('animals', opts)
      JSON.parse(res.body)
    end

    private

    def get_token
      access_token_expired? ? refresh_access_token : @@access_token.token
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
      @@access_token = Requests::AccessToken.new(res)
      @@access_token.token
    end
  end
end
