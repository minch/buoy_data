module BuoyData
  class NoaaBuoyReading < BuoyReading
    format :plain

    attr_accessor :buoy_id, :url, :response

    def initialize(buoy_id, unit_system = self.class.default_unit_system)
      @url = base_url(buoy_id)
      @unit_system = unit_system
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
      parse_response(response)
    end

    def self.source
      :noaa
    end

    def self.google_chart_base(buoy_id)
      url = [ "http://chart.apis.google.com/chart?cht=lc" ]
      url << "chtt=#{buoy_id}"
      url << "chts=666666,12"
      url << "chco=3366FF"
      url << "chs=250x100"
      url << "chds=0,10"
      url << "chl=WVHT".gsub(/ /, '%20')
      url.join('&')
    end


    def self.default_unit_system
      :metric
    end

    private
    def fields_from_response(response)
      fields = response.first.sub(/^#/, '').split
    end

    def response_to_array(response)
      response.parsed_response.split(/\n/)
    end

    def most_recent_from_response(response)
      response[2].split rescue nil
    end

    def reading_to_hash(reading, fields)
      hash = {}
      fields.each_with_index do |field, index|
        hash.store(field, reading[index])
      end

      hash
    end
  end
end
