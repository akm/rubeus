# -*- coding: utf-8 -*-
require 'rubeus/jdbc/meta_element'
module Rubeus::Jdbc
  class Column < TableElement
    include FullyQualifiedNamed

    #  1. TABLE_CAT           String => テーブルカタログ (null の可能性がある)
    #  2. TABLE_SCHEM         String => テーブルスキーマ (null の可能性がある)
    #  3. TABLE_NAME          String => テーブル名
    #  4. COLUMN_NAME         String => 列名
    #  5. DATA_TYPE           short => java.sql.Types からの SQL の型
    #  6. TYPE_NAME           String => データソース依存の型名。UDT の場合、型名は完全指定
    #  7. COLUMN_SIZE         int => 列サイズ。char や date の型については最大文字数、numeric や decimal の型については精度
    #  8. BUFFER_LENGTH        - 未使用
    #  9. DECIMAL_DIGITS      int => 小数点以下の桁数
    # 10. NUM_PREC_RADIX      int => 基数 (通常は、10 または 2 のどちらか)
    # 11. NULLABLE            int => NULL は許されるか
    #         * columnNoNulls         - NULL 値を許さない可能性がある
    #         * columnNullable        - 必ず NULL 値を許す
    #         * columnNullableUnknown - NULL 値を許すかどうかは不明
    # 12. REMARKS             String => コメント記述列 (null の可能性がある)
    # 13. COLUMN_DEF          String => デフォルト値 (null の可能性がある)
    # 14. SQL_DATA_TYPE       int => 未使用
    # 15. SQL_DATETIME_SUB    int => 未使用
    # 16. CHAR_OCTET_LENGTH   int => char の型については列の最大バイト数
    # 17. ORDINAL_POSITION    int => テーブル中の列のインデックス (1 から始まる)
    # 18. IS_NULLABLE         String => "NO" は、列は決して NULL 値を許さないことを意味する。"YES" は NULL 値を許す可能性があることを意味する。空の文字列は不明であることを意味する
    # 19. SCOPE_CATLOG        String => 参照属性のスコープであるテーブルのカタログ (DATA_TYPE が REF でない場合は null)
    # 20. SCOPE_SCHEMA        String => 参照属性のスコープであるテーブルのスキーマ (DATA_TYPE が REF でない場合は null)
    # 21. SCOPE_TABLE         String => 参照属性のスコープであるテーブル名 (DATA_TYPE が REF でない場合は null)
    # 22. SOURCE_DATA_TYPE    short => 個別の型またはユーザ生成 Ref 型、java.sql.Types の SQL 型のソースの型 (DATA_TYPE が DISTINCT またはユーザ生成 REF でない場合は null)
    #
    # see also:
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getColumns(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String)
    #
    attr_accessor :column_name, :data_type, :type_name, :column_size,
    :buffer_length, :decimal_digits, :num_prec_radix,
    :nullable, :remarks, :column_def, :sql_data_type,
    :sql_datetime_sub, :char_octet_length,
    :ordinal_position, :is_nullable,
    :scope_catlog, :scope_schema, :scope_table, :scope_data_type

    alias_method :size, :column_size

    def inspect
      "#<#{self.class.name} #{self.name} #{type_name}(#{size}) #{nullable? ? 'NULL' : 'NOT NULL'}>"
    end


    def name
      column_name.send(options[:name_case] || :to_s)
    end

    def jdbc_type
      @column_type ||= (TYPE_ID_TO_NAMES[data_type] || type_name || '')
    end

    def rails_type
      @rails_type ||= (
        (table.primary_key != self.name) ? JDBC_TYPE_TO_RAILS_TYPE[jdbc_type] :
        (/^id$/ =~ self.name) ? nil : :primary_key
        )
    end

    def rails_type=(value)
      @rails_type = value
    end

    attr_accessor :rails_ignored
    attr_accessor :rails_name, :rails_options
    attr_reader :name_changed?

    def nullable?
      @_nullable ||= (is_nullable != 'NO')
    end

    def primary_key_index
      @primary_key_index ||= table.primary_key_names.index(self.name)
    end

    def primary_key?
      !!primary_key_index
    end
    alias_method :pk?, :primary_key?

    def default
      self.column_def.nil? ? nil :
        /^NULL$/i =~ self.column_def.to_s ? nil : self.column_def
    end
  end
end
