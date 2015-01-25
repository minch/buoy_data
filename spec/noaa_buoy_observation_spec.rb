require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaBuoyObservation do
  before(:each) do
    #FakeWeb.allow_net_connect = false # TODO
  end

  let (:noaa_buoy_observation) { BuoyData::NoaaBuoyObservation.new(41009) }

  context 'get' do
    it 'should get buoy data' do
      noaa_buoy_observation.get
      noaa_buoy_observation.response.code.should == BuoyData::NoaaBuoyObservation::GET_SUCCESS
    end

    it 'should respond to noaa fields' do
      noaa_buoy_observation.get
      noaa_buoy_observation.should respond_to :WVHT
    end

    it 'should generate google chart url' do
      pending
      url = noaa_buoy_observation.google_chart_url
      url.should match(/chart.apis.google.com/)
    end

    it 'should parse date fields' do
      noaa_buoy_observation.get
      noaa_buoy_observation.YY.should match(/^\d{4}$/)
      noaa_buoy_observation.DD.should match(/^\d{2}$/)
      noaa_buoy_observation.hh.should match(/^\d{2}$/)
      noaa_buoy_observation.mm.should match(/^\d{2}$/)
    end
  end

  context 'get_all' do
    it 'should get all' do
      response = noaa_buoy_observation.get_all
      response.should be_a Array
      response.size.should > 1
    end

    it 'should get all' do
      hash = noaa_buoy_observation.get_all.first
      hash.should be_a(Hash)
    end 

    it 'should parse date fields' do
      response = noaa_buoy_observation.get_all
      noaa_buoy_observation = response.first

      noaa_buoy_observation[:YY.to_s].should match(/^\d{4}$/)
      noaa_buoy_observation[:DD.to_s].should match(/^\d{2}$/)
      noaa_buoy_observation[:hh.to_s].should match(/^\d{2}$/)
      noaa_buoy_observation[:mm.to_s].should match(/^\d{2}$/)
    end
  end
end
