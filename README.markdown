# buoy_data

## Description

The goal of this gem is to provide a super simple interface to marine buoy data
from a variety of sources.

Currently only [NOAA buoys](http://www.ndbc.noaa.gov/) are supported but adding more is
planned.


## Install

<pre>
gem install buoy_data
</pre>

## Usage

The basic flow is:

- instantiate a buoy_data object that will represent the target buoy
- call its :get method
- reference the given fields - for the latest reading - via convenient dot notation

<pre>
require 'rubygems'
require 'buoy_data'
noaa_buoy = BuoyData::NoaaBuoy.new(41012) # St Augustine, FL
noaa_buoy.get # get and parse the latest reading for the station
noaa_buoy.WVHT
 => "1.4" 
noaa_buoy.APD
 => "4.6"
# Wow the swell is pumping, I'm moving ;)!
</pre>

Note:  access to the HTTParty response object is available via the :response method.

So, until a more friendly method is added, all of the historical data for the given station
can be obtained via (continuing from the above):

<pre>
noaa_buoy.response.parsed_response.split(/\n/)
</pre>

Which will provide an array of strings (one string per row) for all the historical data
available for the given station.  In other words, for the station in the example above,
41012, you'd get all the data at:

http://www.ndbc.noaa.gov/data/realtime2/41012.spec

as an array of strings.

## TODO

- Add friendly / convenient methods for historical station data
- Webmock for the specs

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
