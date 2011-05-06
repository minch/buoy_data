module BuoyData
  class NoaaBuoyList < BuoyList
    def url
      "#{base_url}/to_station.shtml"
    end

    def base_url
      Noaa::BASE_URL
    end

    def scrape_station(url)
      NoaaStation.new.scrape(url)
    end

    private
    def stations(doc)
      text = "National Data Buoy Center Stations"
      xpath = "//h4[text()='#{text}']/following-sibling::pre/a"

      doc.xpath(xpath).map{|element| element['href']}
    end
  end
end
