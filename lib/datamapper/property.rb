
module DataMapper

  # TODO: Document this file
  class Property
    attr_accessor :position
    attr_accessor :display_name
    attr_accessor :prefix
    attr_accessor :separator
    
    alias original_initialize initialize
    def initialize(model, name, type, options = { })
      pos = options.delete(:position)
      self.position = pos.nil? ? nil : pos.to_i
      
      prefix = options.delete(:prefix)
      self.prefix = prefix.nil?  ? "" : prefix

      if ! self.prefix.empty?
        separator = options.delete(:separator)
        self.separator = separator.nil?  ? "__" : separator
      else
        self.separator = ""
      end
      
      self.display_name = name
      
      name = (self.prefix + self.separator + name.to_s).to_sym
      original_initialize(model, name, type, options)
    end
      
    def <=>(other)
      return  0 if self.position.nil? && other.position.nil?
      return  1 if other.position.nil?
      return -1 if self.position.nil?
      self.position <=> other.position
    end
      
  end
  
end