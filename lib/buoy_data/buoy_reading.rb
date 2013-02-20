module BuoyData
  class BuoyReading
    include HTTParty
    default_timeout 10

    GET_SUCCESS = 200
  end
end
