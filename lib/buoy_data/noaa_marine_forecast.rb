module BuoyData
  require 'open-uri'
  require 'nokogiri'

  # This class scrapes readings from noaa coastal waters forecasts.
  # NOTE:  Currently only grabs today or this evenings forecast.
  class NoaaMarineForecast
    def scrape(url)
      h = {}
      anchors = "MON|TUES|WED|THU|FRI"
      index = 2

      doc = Nokogiri::HTML(open(url))
      content = doc.xpath('//body').text.gsub(/\n/, '')
      matches = /\.(TONIGHT|TODAY)\.\.\.(([A-Z1-9 \.])+)\.(#{anchors})/.match content

      matches[index].chop if matches.length > index
    end

    private
    def logger
      Rails.logger if defined? Rails.logger
    end
  end
end
