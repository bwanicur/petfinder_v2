require 'petfinder_V2/version'
require 'petfinder_V2/client'

module PetfinderV2
  class Error < StandardError; end
  class InvalidRequestOptionsError < Error; end
end
