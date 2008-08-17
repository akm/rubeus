Rubeus::Jdbc.depend_on("Statement")

module Rubeus::Extensions::Java::Sql
  module Connection
    include Rubeus::Jdbc::CloseableResource

    def statement(*args, &block)
      with_close(create_statement(*args), &block)
    end

    def query(sql, &block)
      statement{|st| st.query(sql, &block)}
    end
  end
end
