Rubeus::Jdbc.depend_on("Statement")

module Rubeus::Extensions::Java::Sql
  module DatabaseMetaData
    def table_objects(catalog = nil, schema_pattern = nil, table_name_pattern = nil, options = nil)
      options = { 
        :name_case => nil # nil, :downcase, :upcase
      }.update(options || {})
      tables = getTables(catalog, schema_pattern, table_name_pattern, nil).map do |rs|
        Rubeus::Jdbc::Table.new(self, rs.to_hash, options)
      end
      tables = Rubeus::Util::NameAccessArray.new(*tables)
      
      tables
    end
  end
end
