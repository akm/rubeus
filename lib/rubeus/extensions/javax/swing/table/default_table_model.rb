Rubeus::Swing.depend_on('TableModel')
Rubeus::Swing.depend_on('AbstractTableModel')

module Rubeus::Extensions::Javax::Swing::Table
  module DefaultTableModel
    def self.included(base)
      base.module_eval do
        alias_method :add_row_without_rubeus, :add_row
        alias_method :add_row, :add_row_with_rubeus
        alias_method :insert_row_without_rubeus, :insert_row
        alias_method :insert_row, :insert_row_with_rubeus
      end
      base.extend(ClassMethods)
      base.instance_eval do
        alias :new_without_rubeus :new
        alias :new :new_with_rubeus
      end
    end

    module ClassMethods
      def vectorize_if_array(value)
        value.is_a?(Array) ? java.util.Vector.new(value) : value
      end

      def new_with_rubeus(*args)
        if args.length == 1
          obj = args.first
          if obj.is_a?(Array)
            if obj.first.is_a?(Array)
              data = vectorize_if_array(obj.map{|row| vectorize_if_array(row)})
              column_names = vectorize_if_array((1..obj.first.size).entries)
              return new_without_rubeus(data, column_names)
            else
              column_names = vectorize_if_array(obj)
              return new_without_rubeus(column_names, 0)
            end
          elsif obj.is_a?(Hash)
            options = obj
            rows = options[:data] || options[:rows]
            cols = options[:column_names] || options[:columns]
            if rows.nil? or cols.nil?
              raise ArgumentError, "DefaultTableModel needs (:data or :rows) and (:column_names or :columns) but options was #{options}"
            end
            data = vectorize_if_array(rows.map{|row| vectorize_if_array(row)})
            column_names = vectorize_if_array(cols)
            return new_without_rubeus(data, column_names)
          end
        elsif (args.length == 2) and (args.first.class.name == 'REXML::Document' and args.last.is_a?(Hash))
          result = new_without_rubeus(vectorize_if_array(args.last[:column_paths]), 0)
          result.load_from_xml(*args)
          return result
        end
        return new_without_rubeus(*args)
      end
    end

    attr_accessor :readonly

    def isCellEditable(row, col)
      !readonly
    end

    def vectorize_if_array(value)
      self.class.vectorize_if_array(value)
    end

    def add_row_with_rubeus(row)
      add_row_without_rubeus(vectorize_if_array(row))
    end

    def insert_row_with_rubeus(index, row)
      insert_row_without_rubeus(index, vectorize_if_array(row))
    end

    def load_from_xml(rexml_doc, options = {:refresh_columns => false})
      row_path = options[:row_path]
      col_paths = options[:column_paths]
      if row_path.nil?
        raise ArgumentError, "require :row_path but options was #{options}"
      end
      unless col_paths
        rexml_doc.elements.each(row_path) do |row|
          col_paths = row.elements.map{|prop| prop.name}
          break
        end
      end
      if options[:refresh_columns]
        self.column_count = 0
        (options[:column_names] || col_paths).each{|col_name| add_column(col_name)}
      end
      self.row_count = 0
      rexml_doc.elements.each(row_path) do |row|
        values = col_paths.map do |col_path|
          element = row.elements[col_path]
          element ? element.text :
            options[:ignore_unexist_column] ? nil :
              (raise ArgumentError, "column  '#{col_path}' not found.")
        end
        add_row(values)
      end
    end
  end
end
