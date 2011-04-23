module BuoyData
  class NoaaBuoyList < BuoyList
    def url
      "#{base_url}/to_station.shtml"
    end

    def base_url
      'http://www.ndbc.noaa.gov'
    end

    def scrape_station(url)
      url = [ base_url, url ].join('/')
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
