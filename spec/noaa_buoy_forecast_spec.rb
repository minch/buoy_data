require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoyForecast do
  before(:each) do
    #FakeWeb.allow_net_connect = false # TODO
  end

  let (:noaa_buoy_forecast) { BuoyData::NoaaBuoyForecast.new(41009) }

  context 'get' do
    before(:each) do
      noaa_buoy_forecast.get
    end

    it 'should get buoy data' do
      noaa_buoy_forecast.response.code.should == BuoyData::NoaaBuoyForecast::GET_SUCCESS
    end

    it 'should get buoy data' do
      noaa_buoy_forecast.get.should be_a Array
    end
  end
end
