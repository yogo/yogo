class TypeParser
  
  def self.parse(type)
    case type
    when "tinyint(4)"
      then "Integer"
    when "INTEGER"
      then "Integer"
    when "int(11)"
      then "Integer"
    when "FLOAT"
      then "Float"  
    when "varchar(255)"
      then "String"
    when "TIMESTAMP"
      then "DateTime"
    when "datetime"
      then "DateTime"
    when "boolean"
      then "Boolean"
    when /VARCHAR(\(\d{1,2}\)){0,1}/
      then "String"
    else
      type
    end
  end
  
end