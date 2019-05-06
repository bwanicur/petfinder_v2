module PetfinderV2
  module Services
    class Option
      def initialize(klass, choices = [])
        @klass = klass
        @choices = choices
      end

      def validate_value(value, key)
        if value.respond_to?(:each)
          validate_collection_val(value, key)
        else
          validate_single_val(value, key)
        end
      end

      private

      def validate_single_val(val, key)
        if !val.is_a?(@klass)
          "#{key.capitalize}: #{val} must be a kind of #{@klass}"
        elsif !@choices.empty? && !@choices.include?(val)
          "#{key.capitalize}: #{val} is not an allowed value.  " \
            "The allowed values are: #{@choices.join(',')}"
        end
      end

      def validate_collection_val(collection, key)
        collection.inject([]) { |memo, val| memo << validate_single_val(val, key) }
      end
    end

    class OptionsValidator
      OPTS_MAP = {
        limit: Option.new(Integer),
        breed: Option.new(String),
        color: Option.new(String),
        orgnanization: Option.new(String),
        distance: Option.new(String),
        location: Option.new(String),
        name: Option.new(String),
        page: Option.new(Integer),
        sort: Option.new(String),
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

      def initialize(opts)
        @opts = opts
      end

      def run
        errors = []
        @opts.each do |key, val|
          key = key.to_sym
          if OPTS_MAP[key].nil?
            errors << "#{key} is not a valid option"
            next
          end
          pf_opt = OPTS_MAP[key]
          errors << pf_opt.validate_value(val, key)
        end
        errors.flatten.compact
      end
    end
  end
end
