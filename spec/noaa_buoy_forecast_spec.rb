require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoyForecast do
  before(:each) do
    #FakeWeb.allow_net_connect = false # TODO
  end

  let (:noaa_buoy_forecast) { BuoyData::NoaaBuoyForecast.new(41012) }

  context 'get' do
    before(:each) do
      noaa_buoy_forecast.get
    end

    it 'should get buoy data' do
      noaa_buoy_forecast.response.code.should == BuoyData::NoaaBuoyForecast::GET_SUCCESS
    end

    it 'should get buoy data as json' do
      noaa_buoy_forecast.get
      json = noaa_buoy_forecast.to_json
      json.should be
      # We really should get down and dirty here, thoroughly checking the fields
      hash = JSON.parse(json).first
      hash.should be_a Hash
    end
  end
end
