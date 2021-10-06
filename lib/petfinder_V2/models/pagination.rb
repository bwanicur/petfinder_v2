module PetfinderV2
  module Models
    class Pagination
      attr_reader :count_per_page,
                  :total_count,
                  :current_page,
                  :total_pages,
                  :links

      def initialize(data)
        @count_per_page = data['count_per_page']
        @total_count = data['total_count']
        @current_page = data['current_page']
        @total_pages = data['total_pages']
        @links = data['_links']
      end
    end
  end
end
