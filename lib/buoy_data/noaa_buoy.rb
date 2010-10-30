module BuoyData
  class NoaaBuoy < Buoy
    format :plain

    attr_accessor :buoy_id, :url, :response

    def initialize(buoy_id)
      @url = base_url(buoy_id)
    end

    def metaclass
      class << self
        self
      end
    end

    def get(raw = false)
      response = self.class.get(@url)
      return unless response and response.code == GET_SUCCESS
      return response if raw

      @response = response
      parse_response
    end

    def base_url(buoy_id = @buoy_id)
      @buoy_id ||= buoy_id

      # The following didn't work as the :description field contains markup we'd have
      # to parse
      #"http://www.ndbc.noaa.gov/data/latest_obs/#{id}.rss"

      # TODO:  get historical data from:
      "http://www.ndbc.noaa.gov/data/realtime2/#{buoy_id}.spec"
    end

    def self.source
      :noaa
    end

    def parse_response
      # Get all readings
      response = @response.parsed_response.split(/\n/)

      # The first line are the fields
      fields = response.first.sub(/^#/, '').split

      # The second line are different names of the fields

      # The third line is the most recent reading
      response = response[2].split rescue nil
      return unless response

      # Set instance vars per field so we can use dot notation to reference each
      hash = {}
      fields.each_with_index do |field, index|
        hash.store(field, response[index])
      end

      define_attributes(hash)
    end

    def define_attributes(hash)
      hash.each_pair { |key, value|
        metaclass.send :attr_accessor, key
        send "#{key}=".to_sym, value
      }
    end
  end
end
