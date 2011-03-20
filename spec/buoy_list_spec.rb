require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::BuoyList do
  let (:buoy_list) { BuoyData::BuoyList.new }

  context 'get' do
    it "should get buoy list" do
      buoy_list.should be
      buoy_list.stub(:ndbc_stations).and_return(stubbed_station_list)
      stations = buoy_list.get

      stations.should_not be_empty
    end
  end

  def stubbed_station_list
    [ "station_page.php?station=41012", "station_page.php?station=sauf1" ]
  end
end
