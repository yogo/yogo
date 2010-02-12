
module DataMapper

  class Property
    attr_accessor :position

    alias original_initialize initialize
    def initialize(model, name, type, options = {})
      pos = options.delete(:position)
      self.position = pos.nil? ? nil : pos.to_i
      original_initialize(model, name, type, options)
    end
  
    # alias to_json_schema_hash_without_positon to_json_schema_hash
    # 
    # def to_json_schema_hash_with_position(repo)
    #   json_hash = to_json_schema_hash_without_positon(repo)
    #   json_hash.merge!({"position" => @position }) unless @position.nil?
    # end
    # 
    # alias to_json_schema_hash to_json_schema_hash_with_positon
      
    def <=>(other)
      return  0 if self.position.nil? && other.position.nil?
      return  1 if other.position.nil?
      return -1 if self.position.nil?
      self.position <=> other.position
    end
      
  end
  
end