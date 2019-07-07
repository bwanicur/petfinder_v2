require 'json'

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
      Serializers::Animal.process_collection(response_data)
    end

    def get_animal(id)
      response_data = base_request(:get, "animals/#{id}")
      Serializers::Animal.new(response_data['animal'])
    end

    def get_animal_types
      response_data = base_request(:get, 'types')
      Serializers::AnimalType.process_collection(response_data)
    end

    def get_animal_type(name)
      response_data = base_request(:get, "types/#{name}")
      Serializers::AnimalType.new(response_data['type'])
    end

    def get_animal_breeds(animal_type)
      response_data = base_request(:get, "types/#{animal_type}/breeds")
      Serializers::AnimalBreed.process_collection(response_data)
    end

    def search_organizations(opts = {})
      validate_organization_options!(opts)
      response_data = base_request(:get, 'organizations', opts)
      Serializers::Organization.process_collection(response_data)
    end

    def get_organization(id)
      response_data = base_request(:get, "organizations/#{id}")
      Serializers::Organization.new(response_data['organization'])
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
      Serializers::AccessToken.new(response_data)
    end
  end
end
