require 'json'
require_relative 'config'
require_relative 'services/options_validator'
require_relative 'requests/request'
require_relative 'requests/access_token_request'
require_relative 'models/access_token'
require_relative 'models/animal'

module PetfinderV2
  class Client
    @@access_token = nil
    def self.reset_access_token!
      @@access_token = nil
    end

    def initialize(client_id = nil, client_secret = nil)
      @client_id = client_id || Config.instance.read(:client_id)
      @client_secret = client_secret || Config.instance.read(:client_secret)
    end

    def search_animals(opts = {})
      response_data = base_request(:get, 'animals', opts)
      Models::Animal.process_collection(response_data)
    end

    def search_organizations(opts = {})
      # response_data = base_request(:get, 'organizations', opts)
      # Models::Organization.process_collection(response_data)
    end

    private

    def base_request(http_verb, endpoint, opts)
      validate_options!(opts)
      res = Requests::Request.new(get_token.token)
                             .send(http_verb, endpoint, opts)
      response_data = JSON.parse(res.body)
      handle_errors!(response_data)
      response_data
    end

    def validate_options!(opts)
      errors = PetfinderV2::Services::OptionsValidator.new(opts).run
      unless errors.empty?
        raise(PetfinderV2::InvalidRequestOptionsError, errors.join("\n"))
      end
    end

    def handle_errors!(data)
      return if !data['status'] || data['status'] < 400

      msg = if data['invalid-params']
              data['invalid-params']['message']
            else
              data['detail']
      end
      raise(PetfinderV2::Error, "STATUS: #{data['status']} - #{msg}")
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
      response_data = JSON.parse(res.body)
      handle_errors!(response_data)
      Models::AccessToken.new(response_data)
    end
  end
end
