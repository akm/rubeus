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

    def import_csv(filepath, options = {})
      table_name = (options[:into] || File.basename(filepath, ".*")).downcase
      table = meta_data.table_objects.detect{|t| t.name.downcase == table_name}
      transactional do
        table.import_csv(self, filepath)
      end
    # rescue Exception => e
    #   puts "[#{e.class}] #{e.message}"
    #   raise e
    end

    def transactional
      self.auto_commit, auto_commit_backup = false, self.auto_commit
      begin
        r = yield if block_given?
        self.commit
        return r
      rescue => e
        self.rollback
      ensure
        self.auto_commit = auto_commit_backup
      end
    end
  end
end
