require_relative 'option'
require_relative 'options_validator'

module PetfinderV2
  module Services
    class AnimalOptionsValidator < OptionsValidator
      def my_opts
        {
          limit: Option.new(Integer),
          breed: Option.new(String),
          color: Option.new(String),
          orgnanization: Option.new(String),

          type: Option.new(String, %w[
                             bird
                             cat
                             dog
                             horse
                             rabbit
                             small_and_furry
                             scales_fins_and_other
                           ]),
          size: Option.new(String, %w[
                             small
                             medium
                             large
                             xlarge
                           ]),
          gender: Option.new(String, %w[
                               female
                               male
                               unknown
                             ]),
          age: Option.new(String, %w[
                            baby
                            young
                            adult
                            senior
                          ]),
          coat: Option.new(String, %w[
                             short
                             medium
                             long
                             wire
                             hairless
                             culrly
                           ]),
          status: Option.new(String, %w[
                               adoptable
                               adopted
                               found
                             ])
        }.freeze
      end
    end
  end
end
