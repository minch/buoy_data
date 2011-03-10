require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoyForecast do
  before(:each) do
    #FakeWeb.allow_net_connect = false # TODO
  end

  let (:noaa_buoy_forecast) { BuoyData::NoaaBuoyForecast.new(41012) }

  context 'get' do
    it 'should get buoy data' do
      noaa_buoy_forecast.get
      noaa_buoy_forecast.response.code.should == BuoyData::NoaaBuoyForecast::GET_SUCCESS
    end
  end

  context 'get all' do
    it 'should get all buoy data as json' do
      noaa_buoy_forecast.get_all(:json)
      #noaa_buoy_forecast.response.code.should == BuoyData::NoaaBuoyForecast::GET_SUCCESS
      p noaa_buoy_forecast
    end
  end
end
