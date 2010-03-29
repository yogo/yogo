
module DataMapper

  # This extends the DataMapper property class to include extra properties.
  # 
  # @todo Add more information here.
  #   We need to add more documentation for the options we added here.
  # 
  # @see http://rdoc.info/projects/datamapper/dm-core DataMapper documentation
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Ivan Judson irjudson@gmail.com
  class Property
    
    # @return [Integer]
    attr_accessor :position
    
    # Human readable display name.
    # @return [String]
    attr_accessor :display_name
    
    # @return [String]
    attr_accessor :prefix
    
    # @return [String]
    attr_accessor :separator
    
    # @return [String]
    attr_accessor :units
    
    alias original_initialize initialize
    
    # Initializer for the Property class.
    # 
    # @param [Model] model a Datamapper model the property is to be added to
    # @param [String or Symbol] name The name of the property to be added
    # @param [Class] type The class the property should be
    # @param [Hash] options The options hash
    #   
    # @return [Property] the property that was created. Not useful.
    # 
    # @api public, semipublic, or private
    def initialize(model, name, type, options = { })
      pos = options.delete(:position)
      self.position = pos.nil? ? nil : pos.to_i
      
      self.units = options.delete(:units)
      
      prefix = options.delete(:prefix)
      self.prefix = prefix.nil?  ? "" : prefix

      separator = options.delete(:separator)
      if ! self.prefix.empty?
        self.separator = separator.nil?  ? "__" : separator
      else
        self.separator = ""
      end
      
      self.display_name = name.to_s.gsub("#{self.prefix}#{self.separator}", "")
      
      name = (self.prefix + self.separator + display_name).to_sym
      
      original_initialize(model, name, type, options)
    end

    # Compairson method for properties based on the position.
    # This is primairly useful for sort methods.
    # 
    # @example
    #   property<=>other_property
    # 
    # @param [Property] other The Property to compair to self.
    # 
    # @return [Integer]
    # 
    # @author Robbie Lamb robbie.lamb@gmail.com
    # 
    # @api public
    def <=>(other)
      return  0 if self.position.nil? && other.position.nil?
      return  1 if other.position.nil?
      return -1 if self.position.nil?
      self.position <=> other.position
    end
      
  end
  
end