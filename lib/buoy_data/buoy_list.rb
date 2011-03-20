module BuoyData
  require 'open-uri'
  require 'nokogiri'

  class BuoyList
    def get
      stats = {
        :stations => [],
        :errors => [] 
      }
      @doc = doc
      @station_list = ndbc_stations doc

      @station_list.each do |s|
        begin
          h = scrape_station s
          stats[:stations].push h
        rescue => e
          stats[:errors].push({ :url => s, :error => e })
        end
      end

      stats
    end

    def url
      "#{base_url}/to_station.shtml"
    end

    def base_url
      'http://www.ndbc.noaa.gov'
    end

    def doc
      doc = Nokogiri::HTML(open(url))  
    end

    private
    def ndbc_stations(doc)
      text = "National Data Buoy Center Stations"
      xpath = "//h4[text()='#{text}']/following-sibling::pre/a"

      doc.xpath(xpath).map{|element| element['href']}
    end

    def scrape_station(url)
      url = [base_url, url].join('/')
      doc = Nokogiri::HTML(open(url))  
      h = {}
      xpath = "//h1"

      # Title, Station Id and Description
      title = doc.xpath(xpath).text
      h[:url] = url
      h[:title] = title
      station_id, description = title.split(/ - /)
      station_id = station_id.sub(/station ?/i, '')
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

      h
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
