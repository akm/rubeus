Rubeus::Jdbc.depend_on("ResultSet")

module Rubeus::Extensions::Java::Sql
  module Statement
    include Rubeus::Jdbc::CloseableResource

    def query(sql, &block)
      with_close(execute_query(sql), &block)
    end
  end
end
