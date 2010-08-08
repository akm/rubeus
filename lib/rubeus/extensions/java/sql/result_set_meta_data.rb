module Rubeus::Extensions::Java::Sql
  module ResultSetMetaData
    include Enumerable

    def each(&block)
      return unless block_given?
      @column_count ||= get_column_count
      (1..@column_count).each(&block)
    end

    def columns
      @columns ||= build_columns
    end

    def column_names
      @column_names ||= columns.inject({}) do |dest, column|
        dest[column.index] = column.name
        dest
      end
    end

    def column_index(i)
      i
    end

    private
    def build_columns
      result = []
      attrs = Rubeus::Jdbc::ResultSetColumn::ATTRIBUTES
      each do |i|
        column_hash = attrs.inject({}) do |dest, attr|
          dest[attr] = send(attr, i)
          dest
        end
        result << Rubeus::Jdbc::ResultSetColumn.new(i,column_hash)
      end
      result
    end
  end
end
