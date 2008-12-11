Rubeus::Jdbc.depend_on("Statement")

module Rubeus::Extensions::Java::Sql
  module DatabaseMetaData
    def table_object(catalog = nil, schema_pattern = nil, table_name = nil, options = nil)
      table_objects(catalog, schema_pattern, table_name, options).first
    end
    
    def table_objects(catalog = nil, schema_pattern = nil, table_name_pattern = nil, options = nil)
      @table_objects ||= {}
      unless table_name_pattern.nil?
        key = [catalog, schema_pattern, table_name_pattern].map{|s| s.nil? ? nil : s.to_s.upcase}
        cached = @table_objects[key]
        return [cached] if cached
      end
      
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
          select{|hash|table.same_fqn?(hash)}.
          map{|hash| Rubeus::Jdbc::Column.new(self, table, hash, options)})
      end
      tables.each{|t| @table_objects[t.fqn] = t}
      tables
    end
  end
end
