require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaMarineForecast do
  let (:station) { BuoyData::NoaaMarineForecast.new }

  it "should scrape forecast" do
    url = forecast_url
    data = station.scrape url

    data.should_not be_empty
  end

  private
  def forecast_url
    "http://weather.noaa.gov/pub/data/raw/fz/fzus52.kmfl.cwf.mfl.txt"
  end
end
