module BuoyData
  require 'open-uri'
  require 'nokogiri'

  # This class scrapes readings from noaa stations.
  # A station in this parlance is an noaa resource that does
  # not have wave data (in other words is not necessarily
  # a floating buoy).
  #
  # There is no super class for this model as we don't yet
  # know if this set up will apply for other data sources.
  #
  # NOTE: This class can currently be used to scrape the latest
  # readings for buoys as well.  The reason it exists however
  # is that we can't fetch data for the stations from the .bull
  # files (they don't exists for stations only buoys).

  class NoaaStation
    def scrape(url)
      url = normalize_url url

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

      xpath = "//table/caption[@class='titleDataHeader']["
      xpath += "contains(text(),'Conditions')"
      xpath += " and "
      xpath += "not(contains(text(),'Solar Radiation'))"
      xpath += "]"

      # Get the reading timestamp
      source_updated_at = reading_timestamp(doc, xpath)
      reading[:source_updated_at] = source_updated_at

      # Get the reading data
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

    def normalize_url(url)
      base_url = Noaa::BASE_URL
      /^#{base_url}/.match(url) ? url : [Noaa::BASE_URL, url].join('/')
    end

    def logger
      Rails.logger if defined? Rails.logger
    end

    def reading_timestamp(doc, xpath)
      elements = doc.xpath(xpath).children rescue []
      unless elements.empty?
        begin
          elements = elements.to_a
          elements.reject!{|e|e.name == 'br'}
          s = elements.last.text.sub(/ ?:$/, '')
          time, date = s.split(/ on /)
          month, day, year = date.split(/\//)
          date = [ day, month, year ].join('-')
          hour = time[0..1]
          minutes = time[2..3]
          time = [ hour, minutes ].join(':')
          s = [ date, time ].join('T')
          s = "#{s} UTC"
          t = Time.parse(s).utc if s
        rescue
        end
      end
    end
  end
end
