require 'petfinder_V2/version'
require 'petfinder_V2/client'
require 'petfinder_V2/config'
require 'petfinder_V2/services/animal_options_validator'
require 'petfinder_V2/services/organization_options_validator'
require 'petfinder_V2/requests/request'
require 'petfinder_V2/requests/access_token_request'
require 'petfinder_V2/models/access_token'
require 'petfinder_V2/models/animal'
require 'petfinder_V2/models/animal_type'
require 'petfinder_V2/models/animal_breed'
require 'petfinder_V2/models/organization'

module PetfinderV2
  class Error < StandardError; end
  class InvalidRequestOptionsError < Error; end
end
