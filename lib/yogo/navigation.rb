# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: navigation.rb
# 
module Enumerable
  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
end

module Yogo
  class Navigation
    ##
    # This method gets the list of attributes prepared for use in views
    # 
    # @param [Class] Model The model to get the attributes from
    # 
    # @return [Array of Strings] Attributes array ready for use in views.
    def self.attributes(model)
      model.usable_properties.map { |prop| prop.name.to_s }
    end
    
    ##
    # This method generates a histogram in a hash that is keyed by attribute value 
    # and value is the frequency of that value.
    # 
    # @param [Class] Model The model to get the histogram from
    # @param [String] Attribute Name The attribute to histogram
    # 
    # @return [Hash] Histogram of values for the model, attribute
    # 
    def self.values(model, attribute)
      values = model.all.map { |m| m[attribute.to_sym] }
      values.to_histogram
    end
    
  end # class Nav
end # module Yogo