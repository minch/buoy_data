# buoy_data

The goal of this gem is to provide marine buoy data from a variety of sources.

## Install

<pre>
gem install buoy_data
</pre>

## Usage

<pre>
> require 'rubygems'
 => false 
> require 'buoy_data'
 => true 
> noaa_buoy = BuoyData::NoaaBuoy.new(41114)
 => #<BuoyData::NoaaBuoy:0x00000100ce18e0 @buoy_id=41114, @url="http://www.ndbc.noaa.gov/data/realtime2/41114.spec"> 
> noaa_buoy.get
 => {"YY"=>"2010", "MM"=>"10", "DD"=>"26", "hh"=>"18", "mm"=>"42", "WVHT"=>"1.2", "SwH"=>"0.2", "SwP"=>"11.1", "WWH"=>"1.2", "WWP"=>"4.3", "SwD"=>"ENE", "WWD"=>"ESE", "STEEPNESS"=>"VERY_STEEP", "APD"=>"4.4", "MWD"=>"115"} 
> noaa_buoy.WVHT
 => "1.2" 
> # Wow I'm moving there, the swell is pumping :)!
</pre>

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Adam Weller. See LICENSE for details.
