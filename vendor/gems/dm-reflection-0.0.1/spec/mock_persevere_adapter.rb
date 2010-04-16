class MockPersevereAdapter
  include DataMapper::Reflection::PersevereAdapter

  def initialize(initial_schemas = nil)
    @schemas = initial_schemas || [
      {'id' => 'first',
        'properties' => {
          'id'   => {'type' => 'serial' },
          'name' => {'type' => 'string' }
        }},
        {'id' => 'boots',
          'properties' => {
            'id'   => {"type" => 'serial' },
            'name' => {"type" => 'string' },
            'quantity' => {"type" => 'integer' }
          }},
          {'id' => 'scoped/feet',
            'properties' => {
              'id'   => {"type" => 'serial' },
              'name' => {"type" => 'string' },
              'quantity' => {"type" => 'integer' },
              'boot' => {"type" => {'$ref' => '../boots'} }
          }}
      
      ]
  end
  
  def get_schema(table_name = nil)
    return @schemas if table_name.nil?
    return @schemas.select{|s| s['id'] == table_name }
  end
end