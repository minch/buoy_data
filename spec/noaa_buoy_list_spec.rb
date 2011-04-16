require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoyList do
  let (:buoy_list) { BuoyData::NoaaBuoyList.new }

  context 'get' do
    it "should get buoy list" do
      buoy_list.should be
      buoy_list.stub(:stations).and_return(stubbed_station_list)

      results = buoy_list.get
      results.should_not be_empty
      results[:errors].should be_empty
      stations = results[:stations]
      stations.compact.should_not be_empty
      station = stations.first

      # Verify we have water temp value
      wtmp = station[:wtmp]
      wtmp.should be_kind_of Float
    end
  end

  def stubbed_station_list
    [
      "station_page.php?station=41012",
      "station_page.php?station=sauf1"
    ]
  end
end
