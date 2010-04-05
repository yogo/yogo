# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: navigation.rb
# 
module Enumerable
  ##
  # @example
  #   to_histogram
  # @return [Hash]
  #
  # @author Ivan Judson
  #
  # @api public
  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
end

module Yogo
  class Navigation
    ##
    # @return [Array<String>] gets the list of attributes prepared for use in views
    # 
    # @param [Class] Model The model to get the attributes from
    # 
    # @author Ivan Judson
    #
    # @api public
    def self.attributes(model)
      model.usable_properties.map { |prop| prop.display_name.to_s }
    end
    
    ##
    # @return [Hash] generates a histogram in a hash that is keyed by attribute value 
    # 
    # @param [Class] Model The model to get the histogram from
    # @param [String] Attribute Name The attribute to histogram
    # 
    # @return [Hash] Histogram of values for the model, attribute
    #
    # @author Ivan Judson
    #
    # @api public
    def self.values(model, attribute)
      values = model.all.map { |m| m[attribute.to_sym] }
      values.to_histogram
    end
    
  end # class Nav
end # module Yogo