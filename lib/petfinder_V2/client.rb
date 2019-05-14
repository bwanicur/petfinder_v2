require 'json'
require_relative 'config'
require_relative 'services/animal_options_validator'
require_relative 'services/organization_options_validator'
require_relative 'requests/request'
require_relative 'requests/access_token_request'
require_relative 'models/access_token'
require_relative 'models/animal'
require_relative 'models/organization'

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
      validate_animal_options!(opts)
      response_data = base_request(:get, 'animals', opts)
      Models::Animal.process_collection(response_data)
    end

    def get_animal(id)
      response_data = base_request(:get, "animals/#{id}")
      Models::Animal.new(response_data['animal'])
    end

    def search_organizations(opts = {})
      validate_organization_options!(opts)
      response_data = base_request(:get, 'organizations', opts)
      Models::Organization.process_collection(response_data)
    end

    private

    def base_request(http_verb, endpoint, opts = {})
      res = Requests::Request.new(get_token.token)
                             .send(http_verb, endpoint, opts)
      response_data = JSON.parse(res.body)
      handle_errors!(response_data)
      response_data
    end

    def validate_animal_options!(opts)
      errors = Services::AnimalOptionsValidator.new(opts).run
      invalid_options_error!(errors)
    end

    def validate_organization_options!(opts)
      errors = Services::AnimalOptionsValidator.new(opts).run
      invalid_options_error!(errors)
    end

    def invalid_options_error!(errors)
      raise(InvalidRequestOptionsError, errors.join("\n")) unless errors.empty?
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
