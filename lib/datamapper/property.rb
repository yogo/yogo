
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
      
    def <=>(other)
      return  0 if self.position.nil? && other.position.nil?
      return  1 if other.position.nil?
      return -1 if self.position.nil?
      self.position <=> other.position
    end
      
  end
  
end