require_relative 'address'

module PetfinderV2
  module Models
    class Contact
      attr_reader :phone, :email
      def initialize(data)
        @data = data
        @phone = data['phone']
        @email = data['email']
      end

      def address
        Address.new(@data['address'])
      end
    end
  end
end
