# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: slash_path.rb
# 
#
class String
  def /(str_to_join)
    File.join(self, str_to_join.to_s)
  end
end

class Symbol
  def /(str_to_join)
    self.to_s / str_to_join
  end
end