module BuoyData
  require 'open-uri'
  require 'nokogiri'

  class BuoyList
    def get(options = {})
      default_options = {
        :limit => 0,
        :id => nil,
        :verbose => true
      }
      options = default_options.merge options

      stats = {
        :stations => [],
        :station_count => 0,
        :errors => [],
        :error_count => 0
      }
      @doc = doc
      @station_list = stations doc

      # Probably only relevant for testing
      @station_list = @station_list[0..options[:limit]-1] if options[:limit] > 0
      @station_list = [ url_by_id(options[:id]) ] if options[:id]

      @station_list.each do |station_url|
        puts "scraping --> #{station_url}" if options[:verbose]
        h = scrape_station(station_url)
        stats[:stations].push h
        stats[:station_count] += 1
      end

      stats
    end

    def url_by_id(id)
      "station_page.php?station=#{id}"
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
