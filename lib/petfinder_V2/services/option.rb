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
  end
end
