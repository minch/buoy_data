require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoy do
  before(:each) do
    #WebMock.allow_net_connect! # TODO
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
	end
end
