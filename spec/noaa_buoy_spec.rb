require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoy do
  before(:each) do
    #FakeWeb.allow_net_connect = false # TODO
    @noaa_buoy = BuoyData::NoaaBuoy.new(41114)
  end

  context 'get' do
    it 'should get buoy data' do
      @noaa_buoy.get
      @noaa_buoy.response.code.should == BuoyData::NoaaBuoy::GET_SUCCESS
    end

    it 'should respond to noaa fields' do
      @noaa_buoy.get
      @noaa_buoy.should respond_to :WVHT
    end

    it 'should get all buoy data' do
      @noaa_buoy.get_all.size.should >= 1
    end

    it 'should get all buoy data' do
      @noaa_buoy.google_chart_url.should match(/chart.apis.google.com/)
    end
  end
end
