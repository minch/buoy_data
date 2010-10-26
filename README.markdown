# buoy_data

The goal of this gem is to provide marine buoy data from a variety of sources.

## Install

<pre>
gem install buoy_data
</pre>

## Usage

<pre>
require 'rubygems'
require 'buoy_data'
noaa_buoy = BuoyData::NoaaBuoy.new(41114)
noaa_buoy.get
noaa_buoy.WVHT
 => "1.2" 
# Wow I'm moving there, the swell is pumping :)!
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
