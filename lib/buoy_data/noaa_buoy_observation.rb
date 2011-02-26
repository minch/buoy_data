module BuoyData
  class NoaaBuoyObservation < NoaaBuoyReading
    require 'json/add/core'

    def get_all(format = :plain)
      response = get(true)
      return unless response
      response = response_to_array response

      case format
      when :json
        json_response = []

        fields = fields_from_response response
        # Remvoe the field rows
        response = response[2..response.size-1]

        response.each do |reading|
          reading = reading.split
          json = reading_to_hash(reading, fields).to_json
          json_response.push json
        end

        response = json_response
      end

      response
    end

    def parse_response(response)
      # Get all readings
      response = response_to_array response
      # The first line are the fields
      fields = fields_from_response response

      # The second line are different names of the fields
      # The third line is the most recent reading
      response = most_recent_from_response response
      return unless response

      # Set instance vars per field so we can use dot notation to reference each
      hash = reading_to_hash(response, fields)
      define_attributes(hash)
    end

    def define_attributes(hash)
      hash.each_pair { |key, value|
        metaclass.send :attr_accessor, key
        send "#{key}=".to_sym, value
      }
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
  end
end
