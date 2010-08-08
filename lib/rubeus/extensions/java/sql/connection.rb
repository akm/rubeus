Rubeus::Jdbc.depend_on("Statement")
Rubeus::Jdbc.depend_on("DatabaseMetaData")

module Rubeus::Extensions::Java::Sql
  module Connection
    include Rubeus::Jdbc::CloseableResource

    def statement(*args, &block)
      with_close(create_statement(*args), &block)
    end

    def query(sql, &block)
      statement{|st| st.query(sql, &block)}
    end

    def tables(catalog, schema_pattern, table_name_pattern, options = nil)
      getMetaData.table_objects(catalog, schema_pattern, table_name_pattern, options = nil)
    end
  end
end
