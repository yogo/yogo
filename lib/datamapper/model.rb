module DataMapper
  module Resource
    def to_param
      self.key.first.to_s
    end
  end
end