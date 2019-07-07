module PetfinderV2
  module Serializers
    class Address
      attr_reader :address1, :address2, :city, :state, :postcode, :country

      def initialize(data)
        @data = data
        @address1 = data['address1']
        @address2 = data['address2']
        @city = data['city']
        @state = data['state']
        @postcode = data['postcode']
        @country = data['country']
      end
    end
  end
end
