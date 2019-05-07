require 'json'
require_relative 'config'
require_relative 'services/options_validator'
require_relative 'requests/request'
require_relative 'models/animal'

module PetfinderV2
  class Client
    def initialize(client_id = nil, client_secret = nil)
      @client_id = client_id || Config.instance.read(:client_id)
      @client_secret = client_secret || Config.instance.read(:client_secret)
    end

    def search_animals(opts = {})
      validate_options!(opts)
      res = Requests::Request.new.get('animals', opts)
      response_data = JSON.parse(res.body)
      handle_errors!(response_data)
      Models::Animal.process_collection(response_data)
    end

    private

    def validate_options!(opts)
      errors = PetfinderV2::Services::OptionsValidator.new(opts).run
      unless errors.empty?
        raise(PetfinderV2::InvalidRequestOptionsError, errors.join("\n"))
      end
    end

    def handle_errors!(data)
      return if data['status'] && data['status'] < 400

      msg = data['detail'] || data['invalid-params']['message']
      raise(PetfinderV2::Error, "Status: #{data['status']} - #{msg}")
    end
  end
end
