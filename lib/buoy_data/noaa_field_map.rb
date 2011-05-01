class NoaaFieldMap < FieldMap
  def self.field_map
    f = {
      :wvht => ['Wave Height', 'ft'],
      :dpd => ['Dominant Wave Period', 's'],
      :apd => ['Average Period', 's'],
      :gst => ['Wind Gust', 'kts'],
      :wspd => ['Wind Speed', 'kts'],
      :wdir => ['Wind Direction', 'deg'],
      #:wtmp => ['Water Temperature',"#{String.new('U+00B0')} F"],
      :wtmp => ['Water Temperature',"F"],
      :atmp => ['Air Temperature', "F"]
    } 
  end
end
