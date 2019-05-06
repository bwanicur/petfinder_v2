module PetfinderV2
  module Models
    class Pagination
      ATTS = %w[
        count_per_page
        total_count
        current_page
        total_pages
        _links
      ].freeze

      def initialize(data)
        @data = data
      end

      ATTS.each do |att|
        define_method(att.to_sym) { @data[att] }
      end
    end
  end
end
