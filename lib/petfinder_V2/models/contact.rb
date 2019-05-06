module PetfinderV2
  module Models
    class Address
      ATTS = %w[
        address1
        address2
        city
        state
        postalcode
        country
      ].freeze

      def initialize(data)
        @data = data
      end

      ATTS.each do |att|
        define_method(att.to_sym) { @data[att] }
      end
    end

    class Contact
      def initialize(data)
        @data = data
      end

      def email
        @data['email']
      end

      def phone
        @data['phone']
      end

      def address
        Address.new(@data['address'])
      end
    end
  end
end
