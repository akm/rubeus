# -*- coding: utf-8 -*-
module Rubeus::Jdbc
  # ResultSetMetaDataから生成されます
  class ResultSetColumn
    ATTRIBUTES = [
      :column_index       , #
      :catalog_name       , # String  # 指定された列のテーブルのカタログ名を取得します。
      :column_class_name  , # String  # Java クラスの完全指定された名前を返します。
      :column_display_size, # int     # 指定された列の通常の最大幅を文字数で示します。
      :column_label       , # String  # 印刷や表示に使用する、指定された列の推奨タイトルを取得します。
      :column_name        , # String  # 指定された列の名前を取得します。
      :column_type        , # int     # 指定された列の SQL 型を取得します。
      :column_type_name   , # String  # 指定された列のデータベース固有の型名を取得します。
      :precision          , # int     # 指定された列の 10 進桁数を取得します。
      :scale              , # int     # 指定された列の小数点以下の桁数を取得します。
      :schema_name        , # String  # 指定された列のテーブルのスキーマを取得します。
      :table_name         , # String  # 指定された列のテーブル名を取得します。
      :auto_increment     , # boolean # 指定された列が自動的に番号付けされて読み取り専用として扱われるかどうかを示します。
      :case_sensitive     , # boolean # 列の大文字と小文字が区別されるかどうかを示します。
      :currency           , # boolean # 指定された列がキャッシュの値かどうかを示します。
      :definitely_writable, # boolean # 指定された列の書き込みが必ず成功するかどうかを示します。
      :is_nullable        , # int     # 指定された列に NULL をセットできるかどうかを示します。
      :read_only          , # boolean # 指定された列が絶対的に書き込み可能でないかどうかを示します。
      :searchable         , # boolean # 指定された列を where 節で使用できるかどうかを示します。
      :signed             , # boolean # 指定された列の値が符号付き数値かどうかを示します。
      :writable             # boolean # 指定された列への書き込みを成功させることができるかどうかを示します。
    ]
    attr_reader(*ATTRIBUTES)

    alias_method :index       , :column_index
    alias_method :class_name  , :column_class_name
    alias_method :display_size, :column_display_size
    alias_method :label       , :column_label
    alias_method :name        , :column_name
    alias_method :type_name   , :column_type_name

    alias_method :auto_increment?     , :auto_increment
    alias_method :case_sensitive?     , :case_sensitive
    alias_method :currency?           , :currency
    alias_method :definitely_writable?, :definitely_writable
    # alias_method :nullable?
    alias_method :read_only?          , :read_only
    alias_method :searchable?         , :searchable
    alias_method :signed?             , :signed
    alias_method :writable?           , :writable

    def initialize(index, attributes = {})
      @index = index
      attributes.each do |key, value|
        instance_variable_set("@#{key.to_s}", value)
      end
    end
  end
end
