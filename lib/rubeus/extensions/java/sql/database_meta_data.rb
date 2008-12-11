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

      columns = getColumns(catalog, schema_pattern, table_name_pattern, nil).map{|r| r.to_hash}
      tables.each do |table|
        table.columns = Rubeus::Util::NameAccessArray.new(
          *columns.
          select{|hash|table.match?(hash)}.
          map{|hash| Rubeus::Jdbc::Column.new(self, table, hash, options)})
      end
      
      
      tables
    end
  end
end
