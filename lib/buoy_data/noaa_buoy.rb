module BuoyData
  class NoaaBuoy < Buoy
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
      parse_response
    end

    def get_all
      response = get(true)
      return unless response

      response.parsed_response.split(/\n/)
    end

    #
    # Get a graph of the historical data for the given buoy.
    #
    # Inspired by:
    #
    # https://github.com/thepug/nbdc_graph/blob/master/generate_graphs.py
    #
    def google_chart_url
      max = 120
      response = get_all
      return unless response

      historical_data = []
      response.each_with_index do |row, index|
        break if index >= max
        next if row.match(/^#/)

        row = row.split(/  ?/)
        historical_data << row[5]
      end
      return if historical_data.blank?
      historical_data = historical_data.join(',')

      [ self.class.google_chart_base(@buoy_id), '&chd=t:', historical_data ].join
    end

    def base_url(buoy_id = @buoy_id)
      @buoy_id ||= buoy_id

      # The following didn't work as the :description field contains markup we'd have
      # to parse
      #"http://www.ndbc.noaa.gov/data/latest_obs/#{id}.rss"
      #
      # Could also consider:
      #
      # http://www.ndbc.noaa.gov/data/5day2/41012_5day.txt
      #
      # It has more fields but seems to be an hour hehind the below.

      "http://www.ndbc.noaa.gov/data/realtime2/#{buoy_id}.spec"
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
