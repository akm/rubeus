Rubeus::Jdbc.depend_on("Statement")

module Rubeus::Extensions::Java::Sql
  module DatabaseMetaData
    def included(mod)
      mod.module_eval do
        alias_method :getTables_without_rubeus, :getTables
        alias_method :getTables, :getTables_with_rubeus
      end
    end

    def getTables_with_rubeus(*args, &block)
      case args.length
        when 0, 1 then table_objects(*args, &block)
        else getTables_without_rubeus(*args, &block)
      end
    end
    alias_method :tables, :getTables_with_rubeus

    def table_object(table_name, options = nil)
      options = {:table_name_pattern => table_name}.update(options || {})
      table_objects(options).first
    end
    alias_method :table, :table_object

    def table_objects(options = nil)
      options = {
        :catalog => nil,
        :schema => nil,
        :schema_pattern => nil,
        :table => nil,
        :table_name => nil,
        :table_name_pattern => nil,
        :name_case => nil # nil, :downcase, :upcase
      }.update(options || {})
      catalog = options[:catalog]
      schema_pattern = options[:schema_pattern] || options[:schema]
      table_name_pattern = options[:table_name_pattern] || options[:table_name] || options[:table]

      @table_objects ||= {}
      unless table_name_pattern.nil?
        key = [catalog, schema_pattern, table_name_pattern].map{|s| s.nil? ? nil : s.to_s.upcase}
        cached = @table_objects[key]
        return [cached] if cached
      end

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
