module DataMapper
  module Associations
    class Relationship
      
      # Position
      # @example property.position
      # @return [Integer]
      # @api public
      attr_accessor :position

      # Human readable display name
      # @example property.display_name
      # @return [String]
      # @api public
      attr_accessor :display_name

      # Prefix
      # @example property.prefix
      # @return [String]
      # @api public
      attr_accessor :prefix
      
      # Original Initialize
      # @example orginal_initialize
      # @return 
      # @api public
      alias original_initialize initialize
      
      ##
      # Initializer for a relationship
      # 
      # This isn't really useful on it's own.
      # 
      # @example
      #  Relatipnship.new('blah blah')
      # 
      # @return [Relationship]
      #   The created relationship object.
      # 
      # @api public
      # @author lamb
      def initialize(name, child_model, parent_model, options = {})

        pos = options.delete(:position)
        self.position = pos.nil? ? nil : pos.to_i

        prefix = options.delete(:prefix)
        self.prefix = prefix.nil?  ? "" : prefix
        
        self.display_name = name.to_s.sub("#{self.prefix}", "")

        original_initialize(name, child_model, parent_model, options)
      end
    end
  end
end