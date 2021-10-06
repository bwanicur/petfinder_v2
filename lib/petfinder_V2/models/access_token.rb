module PetfinderV2
  module Models
    class AccessToken
      attr_reader :token, :expires_at
      def initialize(data)
        @token = data['access_token']
        @expires_at = Time.now + data['expires_in'].to_i
      end
    end
  end
end
