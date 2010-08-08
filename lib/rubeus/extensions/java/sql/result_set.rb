Rubeus::Jdbc.depend_on("ResultSetMetaData")

module Rubeus::Extensions::Java::Sql
  module ResultSet
    include Enumerable

    def each(&block)
      return unless block_given?
      yield(self) while self.next
    end

    def each_array
      each{|rs| yield(rs.to_a)}
    end

    def each_hash
      each{|rs| yield(rs.to_hash)}
    end

    def to_a(default_value = nil)
      meta_data.map{|i| get_object(i) || default_value}
    end

    def to_hash
      column_names = meta_data.column_names
      meta_data.inject({}) do |dest, i|
        dest[column_names[i]] = get_object(i)
        dest
      end
    end
  end
end
