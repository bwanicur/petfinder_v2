require 'singleton'

module PetfinderV2
  class Config
    include Singleton

    @@conf = {}

    def set(key, value)
      @@conf[key] = value
    end

    def read(key)
      key ? (@@conf[key.to_s] || @@conf[key.to_sym]) : @@conf
    end
  end
end
