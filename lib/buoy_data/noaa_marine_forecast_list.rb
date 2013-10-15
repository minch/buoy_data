module BuoyData
  require 'open-uri'
  require 'nokogiri'

  class NoaaMarineForecastList
    def get(options = {})
      default_options = {
        :limit => 0,
        :id => nil,
        :verbose => true
      }
      options = default_options.merge options

      @doc = doc
      @list = forecasts doc
    end

    def url
      [ base_url, path ].join '/'
    end

    def base_url
      "http://www.nws.noaa.gov"
    end

    def path
      "om/marine/forecast.htm"
    end

    def doc
      doc = Nokogiri::HTML(open(url))
    end

    private
    def forecasts(doc)
      # For now we'll only grab the Coastal Water Forecasts
      text = "COASTAL WATERS FORECASTS"
      xpath = "//td/b[text()='#{text}']/../../../tr/td/a"

      elements = doc.xpath(xpath)
      elements = elements.map do |element|
        href = element['href']
        next unless /pub\/data\/raw/.match href
        station = element.text.gsub(/(\s|\n)+/, '')
        next unless station && href

        [ station, href ]
      end

      elements
    end
  end
end
