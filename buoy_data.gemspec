# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{buoy_data}
  s.version = "1.0.0.beta.6"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Weller"]
  s.date = %q{2011-07-10}
  s.description = %q{The goal of this gem is to provide marine buoy data from a variety of sources}
  s.email = %q{minch@trazzler.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "buoy_data.gemspec",
    "lib/buoy_data.rb",
    "lib/buoy_data/buoy_list.rb",
    "lib/buoy_data/buoy_reading.rb",
    "lib/buoy_data/field_map.rb",
    "lib/buoy_data/noaa.rb",
    "lib/buoy_data/noaa_buoy_forecast.rb",
    "lib/buoy_data/noaa_buoy_list.rb",
    "lib/buoy_data/noaa_buoy_observation.rb",
    "lib/buoy_data/noaa_buoy_reading.rb",
    "lib/buoy_data/noaa_field_map.rb",
    "lib/buoy_data/noaa_station.rb",
    "spec/noaa_buoy_forecast_spec.rb",
    "spec/noaa_buoy_list_spec.rb",
    "spec/noaa_buoy_observation_spec.rb",
    "spec/noaa_station_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/minch/buoy_data}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Fetch marine buoy data from various sources}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<buoy_data>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<buoy_data>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<buoy_data>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end

