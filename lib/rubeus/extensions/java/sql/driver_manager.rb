module Rubeus::Extensions::Java::Sql
  module DriverManager
    extend Rubeus::Jdbc::CloseableResource

    def connect(url, user, password, &block)
      with_close(get_connection(url, user, password), &block)
    end
  end
end
