module PetfinderV2
  module Services
    class OptionsValidator
      BASE_OPTS_MAP = {
        name: Option.new(String),
        distance: Option.new(Integer),
        location: Option.new(String),
        page: Option.new(Integer),
        sort: Option.new(String)
      }.freeze

      def initialize(opts)
        @opts = opts
      end

      def my_opts
        raise 'Abstract Method - Only call in subclasses'
      end

      def run
        errors = []
        my_opts_map = BASE_OPTS_MAP.merge(my_opts)
        @opts.each do |key, val|
          key = key.to_sym
          if my_opts_map[key].nil?
            errors << "#{key} is not a valid option"
            next
          end
          pf_opt = my_opts_map[key]
          errors << pf_opt.validate_value(val, key)
        end
        errors.flatten.compact
      end
    end
  end
end
