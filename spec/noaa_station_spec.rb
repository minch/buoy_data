require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaStation do
  let (:station) { BuoyData::NoaaStation.new }

  it "should scrape station" do
    url = station_url
    data = station.scrape url
    data.should_not be_empty
    data.should be_a(Hash)

    data[:wtmp].should be_a(Float)
    source_updated_at = data[:source_updated_at]
    source_updated_at.should be_a(Time)
    source_updated_at.zone.should == 'UTC'
  end

  it "should scrape buoy" do
    url = buoy_url
    data = station.scrape url
    data.should_not be_empty
    data.should be_a(Hash)

    data[:wtmp].should be_a(Float)
    source_updated_at = data[:source_updated_at]
    source_updated_at.should be_a(Time)
    source_updated_at.zone.should == 'UTC'
    p source_updated_at
  end

  def station_url
    "station_page.php?station=lkwf1"
  end

  def buoy_url
    "station_page.php?station=41009"
  end
end
