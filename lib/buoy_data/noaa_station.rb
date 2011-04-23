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

      unless latlng.blank?
        h[:lat] = normal_lat latlng.first
        h[:lng] = normal_lng latlng.last
      end

      # Latest reading
      current_reading = {}

      current_reading = latest_reading doc

      # If we couldn't get a water temp from this station then it's not of use
      return {} unless valid_reading? current_reading
      h.merge! current_reading

      h
    end

    # Do the best we can but get something
    def latest_reading(doc)
      # Check the current reading
      reading = current_reading doc

      # If we don't have a wave height (:wvht) then let's check the previous reading
      unless reading[:wvht]
        p_reading = previous_reading doc
        reading = p_reading if p_reading[:wvht]
      end

      reading
    end

    # Reding from the 'Conditions at..as of..' table
    def current_reading(doc)
      reading = {}
      xpath = "//table/caption[@class='titleDataHeader'][text()[contains(.,'Conditions')]]"
      xpath += "/../tr"
      elements = doc.xpath xpath

      unless elements.empty?
        elements.each do |element|
          r = scrape_condition_from_element(element)
          reading.merge! r unless r.blank?
        end
      end

      reading
    end

    # Most recent observation from the 'Previous observations' table
    # This is unfinished, will need to capture the markup when the
    # current reading is not avaliable and stub it w/fakeweb...
    def previous_reading(doc)
      reading = {}
      text = 'Previous observations'
      xpath = "//table/caption[@class='dataHeader'][text()[contains(.,'#{text}')]]"

      xpath += "/../tr/td"
      elements = doc.xpath xpath

      #unless elements.empty?
        #elements.each do |element|
          #p element.text
        #end
      #end

      reading
    end

    private
    # No water temp (wtmp) is our filter
    def valid_reading?(reading)
      !reading.blank? && reading.keys.include?(:wtmp)
    end

    def scrape_condition_from_element(element)
      reading = {}
      regexp = /\(([A-Z]+)\):\n\n?\t? ?(.*)\n$/m
      text = element.text

      if regexp.match(text)
        key = $1
        return reading unless key
        key = key.downcase.to_sym
        value = $2
        return reading unless value
        value = $1 if value =~ /([0-9.]+)/
        value = value.lstrip.rstrip.to_f
        reading = { key => value }
      end

      reading
    end

    def lat_lng_from(text)
      text = text.sub(/ \(.*$/, '') rescue nil
      return unless text
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
