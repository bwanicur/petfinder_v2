require 'json'
require_relative 'config'
require_relative 'requests/request'
require_relative 'models/animal'

module PetfinderV2
  class Client
    def initialize(client_id = nil, client_secret = nil)
      @client_id = client_id || Config.instance.read(:client_id)
      @client_secret = client_secret || Config.instance.read(:client_secret)
    end

    def search_animals(opts = {})
      res = Requests::Request.new.get('animals', opts)
      Models::Animal.process_collection(JSON.parse(res.body))
    end
  end
end
