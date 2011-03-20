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
      @station_list = stations doc

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
    end

    def base_url
    end

    def doc
      doc = Nokogiri::HTML(open(url))  
    end

    private
    def stations(doc)
    end

    def scrape_station(url)
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
