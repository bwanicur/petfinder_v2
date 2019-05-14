require_relative 'option'
require_relative 'options_validator'

module PetfinderV2
  module Services
    class OrganizationOptionsValidator < OptionsValidator
      def my_opts
        {
          state: Option.new(String),
          country: Option.new(String),
          query: Option.new(String)
        }
      end
    end
  end
end
