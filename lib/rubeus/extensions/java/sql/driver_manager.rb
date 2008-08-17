Rubeus::Jdbc.depend_on("Connection")

module Rubeus::Extensions::Java::Sql
  module DriverManager
    def self.included(base)
      base.extend ClassMethods
      base.extend Rubeus::Jdbc::CloseableResource
    end

    module ClassMethods
      def connect(url, user, password, &block)
        with_close(get_connection(url, user, password), &block)
      end
    end
  end
end
