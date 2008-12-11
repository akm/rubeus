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
    
    attr_accessor :column_name, :key_seq, :pk_name

    alias_method :seq, :key_seq
    
    def name
      column_name.send(options[:name_case] || :to_s)
    end
  end
end
