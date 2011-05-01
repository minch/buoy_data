module BuoyData
  require 'open-uri'
  require 'nokogiri'

  class BuoyList
    def get(limit = 0)
      stats = {
        :stations => [],
        :station_count => 0,
        :errors => [],
        :error_count => 0
      }
      @doc = doc
      @station_list = stations doc

      # Only relevant for testing
      @station_list = @station_list[0..limit] if limit > 0

      @station_list.each do |station_url|
        #p station_url
        
        #begin
          h = scrape_station(station_url)
          stats[:stations].push h
          stats[:station_count] += 1
        #rescue => e
          #stats[:error_count] += 1
          #stats[:errors].push({ :url => station_url, :error => e.backtrace })
        #end
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
  end
end
