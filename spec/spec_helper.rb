class String
  def /(other)
    File.join(self, other)
  end
end

class File
  def self.here
    dirname(__FILE__)
  end
end

require File.here / '..' / 'lib' / 'buoy_data'

# TODO:  add webmock
