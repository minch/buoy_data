module BuoyData
  require 'open-uri'
  require 'nokogiri'

  class NoaaStation
    def scrape(url)
      h = {}
      xpath = "//h1"

      doc = Nokogiri::HTML(open(url))  

      # Title, Station Id and Description
      title = doc.xpath(xpath).first.text
      title = title.rstrip
      h[:url] = url
      h[:title] = title
      station_id, description = title.split(/ - /)
      station_id = station_id.sub(/station ?/i, '')
      station_id = /[A-Z0-9]+/.match(station_id).to_s rescue nil
      h[:station_id] = station_id
      h[:description] = description

      # Lat and Lng
      xpath += "/following-sibling::table/tr/td/p/b"
      elements = doc.xpath(xpath)
      elements = elements.map(&:text)
      element = elements.find{|e| /\d{2,3}\.\d{2,3}/.match(e)}
      latlng = lat_lng_from element

      unless latlng.empty?
        h[:lat] = normal_lat latlng.first
        h[:lng] = normal_lng latlng.last
      end

      # Latest reading
      xpath = "//table/caption[@class='titleDataHeader'][text()[contains(.,'Conditions')]]"
      xpath += "/../tr"
      elements = doc.xpath xpath

      current_reading = {}
      unless elements.empty?
        elements.each do |element|
          reading = scrape_condition_from_element(element)  
          current_reading.merge! reading unless reading.blank?
        end
      end

      # If we couldn't get a water temp from this station then it's not of use
      return {} unless valid_reading? current_reading
      h.merge! current_reading

      h
    end

    private
    # No water temp (wtmp) is our filter
    def valid_reading?(reading)
      !reading.blank? && reading.keys.include?(:wtmp)
    end

    def scrape_condition_from_element(element)
      reading = {}
      # (include units)
      #regexp = /\(([A-Z]+)\):\n\t ?(.*)\n$/
      # (no units)
      regexp = /\(([A-Z]+)\):\n\t ?([0-9.-]+).*\n$/
      text = element.text

      if regexp.match(text)
        key = $1
        return reading unless key
        key = key.downcase.to_sym
        value = $2
        return reading unless value
        value = value.lstrip.rstrip.to_f
        reading = { key => value }
      end

      reading
    end

    def lat_lng_from(text)
      text = text.sub(/ \(.*$/, '')
      matches = /([0-9\.]+ ?[NESW]) ([0-9\.]+ ?[NESW])/.match(text)

      matches && matches.size == 3 ? [ $1, $2 ] : []
    end

    def normal_lat(lat)
      lat, dir = lat.split(/ /)
      lat = lat.to_f
      lat = -lat if dir == 'S'

      lat
    end

    def normal_lng(lng)
      lng, dir = lng.split(/ /)
      lng = lng.to_f
      lng = -lng if dir == 'W'

      lng
    end
  end
end
