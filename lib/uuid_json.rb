require 'uuidtools'

class UUIDTools::UUID
  def as_json(options={})
    to_s
  end
end
