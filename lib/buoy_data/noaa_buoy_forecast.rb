module BuoyData
  class NoaaBuoyForecast < NoaaBuoyReading
    require 'json/add/core'

    def get_all(format = :plain)
      response = get(true)
      return unless response
      response = parse_response response

      # TODO:  finish
      case format
      when :json
        json_response = []

        response = json_response
      end

      response
    end

    private

    def parse_response(response)
      # Get all readings
      response = response_to_array response

      # Remove header and footer
      response = remove_header_from response
      response = remove_footer_from response

      response = parse_noaa_bull_response response

      response
    end

    def parse_noaa_bull_response(response)
      parsed_response = []

      #
      # Split on pipes so we can get the swell breakdown
      #
      response = response.map{|row| row.split(/\|/)}

      # The first column is always empty
      response = response.map{|row| row[1..row.size-1]}
      
      #
      # Now we have eight columns
      #
      # 1: day and hour
      # 2: Total Significant wave height and exclusions (Hst, n and x)
      # 3-7: Up to 6 swell breakdowns (* Hs, Tp, dir)
      #
      # Where:
      #
      # Hst : Total significant wave height.
      # n   : Number of fields with Hs > 0.05 in 2-D spectrum.
      # x   : Number of fields with Hs > 0.15 not in table.
      # Hs  : Significant wave height of separate wave field.
      # Tp  : Peak period of separate wave field.
      # dir : Mean direction of separate wave field.
      # *   : Wave generation due to local wind probable.
      #

      days_and_hours = response.map{|row| row.first.strip.split(/\s+/)}

      #
      # totals
      #
      totals = response.map{|row| row[1].strip.split(/\s+/)}

      #
      # up to 6 swells
      #
      separate_waves = response.map{|row| row[2..7].map{|col| parse_separate_wave(col)}}

      # build the parsed_response
      num = response.size-1
      num.times do |index|
        row = []

        row.push days_and_hours[index]
        row.push totals[index]
        separate_waves[index].each do |sw|
          row.push sw
        end

        parsed_response.push row
      end

      parsed_response
    end

    # Example: "* 1.3 5.3 298"
    def parse_separate_wave(separate_wave)
      # There's probably a slicker way but...
      separate_wave = separate_wave.split(/\s+/)

      # The first column, the wind probable '*', may or may not be present
      # In either cases we have an empty string as the first field
      separate_wave.size == 5 ? separate_wave.shift : separate_wave

      separate_wave
    end

    def base_url(buoy_id = @buoy_id)
      @buoy_id ||= buoy_id

      # NOTE:  The bull files will probably change per ocean/geo:
      # E.g., there are two model runs for the northern atlantic:
      #"http://polar.ncep.noaa.gov/waves/latest_run/nah.#{buoy_id}.bull"

      "http://polar.ncep.noaa.gov/waves/latest_run/wna.#{buoy_id}.bull"
    end

    # The header is the first 7 lines
    def remove_header_from(response)
      response[7..response.size-1]
    end

    # The footer is the last 8 lines
    def remove_footer_from(response)
      response[0..response.size-11]
    end
  end
end
