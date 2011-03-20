module BuoyData
  class NoaaBuoyList < BuoyList
    def url
      "#{base_url}/to_station.shtml"
    end

    def base_url
      'http://www.ndbc.noaa.gov'
    end

    private
    def stations(doc)
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
  end
end
