# -*- coding: utf-8 -*-
require 'rubeus/jdbc/meta_element'
module Rubeus::Jdbc
  class PrimaryKey < TableElement
    include FullyQualifiedNamed

    # 1. TABLE_CAT String => テーブルカタログ (null の可能性がある)
    # 2. TABLE_SCHEM String => テーブルスキーマ (null の可能性がある)
    # 3. TABLE_NAME String => テーブル名
    # 4. COLUMN_NAME String => 列名
    # 5. KEY_SEQ short => 主キー中の連番
    # 6. PK_NAME String => 主キー名 (null の可能性がある)
    #
    # see also:
    # http://java.sun.com/j2se/1.5.0/ja/docs/ja/api/java/sql/DatabaseMetaData.html#getPrimaryKeys(java.lang.String,%20java.lang.String,%20java.lang.String)

    attr_accessor :column_names, :pk_name

    # attr_accessor :key_seq # key_seq はこのインスタンス生成時のcolumn_namesの要素の順番として保持されます。
    # alias_method :seq, :key_seq

    def inspect
      "#<#{self.class.name} #{table.name}(%s)>" % column_names.join(',')
    end

    def [](index)
      column_names[index]
    end

    def length
      column_names.length
    end

    def name
      column_names.send(options[:name_case] || :to_s).join(",")
    end

    def columns
      @columns ||= Rubeus::Util::NameAccessArray.new(*
        column_names.map{|col_name| table.columns[col_name]})
    end

  end
end
