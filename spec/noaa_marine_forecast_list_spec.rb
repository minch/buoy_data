require File.join(File.dirname(__FILE__), 'spec_helper')

describe BuoyData::NoaaMarineForecastList do
  let (:forecast_list) { BuoyData::NoaaMarineForecastList.new }

  context 'get' do
    it "should get buoy list" do
      forecast_list.should be
      results = forecast_list.get
      results.should_not be_empty
    end
  end
end
