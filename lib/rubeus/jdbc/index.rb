# -*- coding: utf-8 -*-
require 'rubeus/jdbc/meta_element'
module Rubeus::Jdbc
  class Index < TableElement
    include FullyQualifiedNamed

    #  1. TABLE_CAT String => テーブルカタログ (null の可能性がある)
    #  2. TABLE_SCHEM String => テーブルスキーマ (null の可能性がある)
    #  3. TABLE_NAME String => テーブル名
    #  4. NON_UNIQUE boolean => インデックス値は一意でない値にできるか。TYPE が tableIndexStatistic の場合は false
    #  5. INDEX_QUALIFIER String => インデックスカタログ (null の可能性がある)。TYPE が tableIndexStatistic の場合は null
    #  6. INDEX_NAME String => インデックス名。TYPE が tableIndexStatistic の場合は null
    #  7. TYPE short => インデックスの型
    #         * tableIndexStatistic - テーブルのインデックスの記述に連動して返されるテーブルの統計情報を識別する
    #         * tableIndexClustered - クラスタ化されたインデックス
    #         * tableIndexHashed - ハッシュ化されたインデックス
    #         * tableIndexOther - インデックスのその他のスタイル
    #  8. ORDINAL_POSITION short => インデックス中の列シーケンス。TYPE が tableIndexStatistic の場合は 0
    #  9. COLUMN_NAME String => 列名。TYPE が tableIndexStatistic の場合は null
    # 10. ASC_OR_DESC String => 列ソートシーケンス、「A」=> 昇順、「D」=> 降順、ソートシーケンスがサポートされていない場合は、null の可能性がある。TYPE が tableIndexStatistic の場合は null
    # 11. CARDINALITY int => TYPE が tableIndexStatistic の場合、テーブル中の列数。そうでない場合は、インデックス中の一意の値の数
    # 12. PAGES int => TYPE が tableIndexStatistic の場合、テーブルで使用されるページ数。そうでない場合は、現在のインデックスで使用されるページ数
    # 13. FILTER_CONDITION String => もしあれば、フィルタ条件 (null の可能性がある)
    #
    # see also:
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getIndexInfo(java.lang.String,%20java.lang.String,%20java.lang.String,%20boolean,%20boolean)
    #
    RECORD_UNIQUE_ATTRS = [:table_cat, :table_schem, :table_name, :non_unique, :index_qualifier, :index_name]
    ATTR_NAMES = [:table_cat, :table_schem, :table_name, :non_unique, :index_qualifier, :index_name, :type,
      # :orinal_position, :column_name, :asc_or_desc, :cardinality,
      :pages, :filter_condition]
    attr_accessor(*(ATTR_NAMES - [:table_cat, :table_schem, :table_name]))

    def inspect
      "#<#{self.class.name} #{table.name}.#{name}(%s)>" % 
        keys.map{|k| k.name + (k.desc? ? " DESC" : '')}.join(',')
    end

    def name
      index_name.send(options[:name_case] || :to_s)
    end

    def keys
      @key ||= Rubeus::Util::NameAccessArray.new
    end

    class Key < MetaElement
      #  8. ORDINAL_POSITION short => インデックス中の列シーケンス。TYPE が tableIndexStatistic の場合は 0
      #  9. COLUMN_NAME String => 列名。TYPE が tableIndexStatistic の場合は null
      # 10. ASC_OR_DESC String => 列ソートシーケンス、「A」=> 昇順、「D」=> 降順、ソートシーケンスがサポートされていない場合は、null の可能性がある。TYPE が tableIndexStatistic の場合は null
      # 11. CARDINALITY int => TYPE が tableIndexStatistic の場合、テーブル中の列数。そうでない場合は、インデックス中の一意の値の数

      ATTR_NAMES = [:orinal_position, :column_name, :asc_or_desc, :cardinality] #, :pages, :filter_condition
      attr_accessor(*(ATTR_NAMES - [:table_cat, :table_schem, :table_name]))

      def initialize(meta_data, index, *args, &block)
        super(meta_data, *args, &block)
        @index = index
      end

      def name
        column_name.send(options[:name_case] || :to_s)
      end

      def pretty_print_instance_variables
        super - [:@index]
      end

      def desc?; asc_or_desc == 'D' end
      def asc?; !desc? end
    end
  end
end
