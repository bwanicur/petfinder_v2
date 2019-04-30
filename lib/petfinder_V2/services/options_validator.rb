module PetfinderV2
  module Services
    class OptionsValidator

      OPTS_MAP = {
        type: [
          :bird,
          :cat,
          :dog,
          :horse,
          :rabbit,
          :small_and_furry,
          :scales_fins_and_other
        ],
        size: [
          :small,
          :medium,
          :large,
          :xlarge
        ],
        gender: [
          :female,
          :male,
          :unknown
        ],
        age: [
          :baby,
          :young,
          :adult,
          :senior
        ],
        coat: [
          :short,
          :medium,
          :long,
          :wire,
          :hairless,
          :culrly
        ],
        status: [
          :adoptable,
          :adopted,
          :found
        ]
      }

      def initialize(opts)
        @opts = opts
      end

      def run
        errors = []
        @opts.each do |key, values|
          key = key.to_sym
          next if OPTS_MAP[key].nil?
          values = [ values ] unless values.respond_to?(:each)
          values.each do |val|
            if !OPTS_MAP[key].include?(val.to_sym)
              errors << "'#{val}' is not an accepted value for #{key}.  " +
                "Here are the excepted values: #{OPTS_MAP[key].join(',')}"
            end
          end
        end
        errors
      end

    end
  end
end
