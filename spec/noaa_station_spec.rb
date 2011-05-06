require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaStation do
  let (:station) { BuoyData::NoaaStation.new }

  it "should scrape station" do
    data = station.scrape station_url
    data.should_not be_empty
    data.should be_a(Hash)
    data[:wtmp].should be_a(Float)
  end

  def station_url
    #"station_page.php?station=41012",
    "station_page.php?station=sauf1"
  end
end
