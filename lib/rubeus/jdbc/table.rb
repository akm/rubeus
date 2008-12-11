# -*- coding: utf-8 -*-
require 'rubeus/jdbc/meta_element'
require "rubeus/jdbc/column"
module Rubeus::Jdbc
  class Table < MetaElement
    
    #  1. TABLE_CAT       String => テーブルカタログ (null の可能性がある)
    #  2. TABLE_SCHEM     String => テーブルスキーマ (null の可能性がある)
    #  3. TABLE_NAME      String => テーブル名
    #  4. TABLE_TYPE      String => テーブルの型。典型的な型は、"TABLE"、"VIEW"、"SYSTEM TABLE"、"GLOBAL TEMPORARY"、"LOCAL TEMPORARY"、"ALIAS"、"SYNONYM" である
    #  5. REMARKS         String => テーブルに関する説明
    #  6. TYPE_CAT        String => の型のカタログ (null の可能性がある)
    #  7. TYPE_SCHEM      String => の型のスキーマ (null の可能性がある)
    #  8. TYPE_NAME       String => の型名 (null の可能性がある)
    #  9. SELF_REFERENCING_COL_NAME String => 型付きテーブルの指定された「識別子」列の名前 (null の可能性がある)
    # 10. REF_GENERATION  String => SELF_REFERENCING_COL_NAME の値の作成方法を指定する。値は、"SYSTEM"、"USER"、"DERIVED" (null の可能性がある) 
    # 
    # see also:
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getTables(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String[])
    # 
    attr_accessor :table_cat, :table_schem, :table_name, 
    :table_type,
    :remarks, :type_cat, :type_schem, :type_name, 
    :self_referencing_col_name, :ref_generation
    alias_method :name, :table_name
    
    attr_accessor :pluralize_table_name
    attr_accessor :columns
    attr_accessor :primary_keys
    attr_accessor :imported_keys
    attr_accessor :exported_keys
    attr_reader :indexes
    
    def initialize(meta_data, attrs, options)
      super(meta_data, attrs, options)
      @indexes = []
    end
    
    def name
      table_name.send(options[:name_case] || :to_s)
    end

    def primary_key
      primary_keys.nil? ? nil :
        primary_keys.empty? ? nil : 
        primary_keys.length == 1 ? primary_keys.first : nil
    end
    
    MATCHING_ATTRS = %w(TABLE_CAT TABLE_SCHEM TABLE_NAME)
    
    def match?(meta_data)
      MATCHING_ATTRS.all?{|attr|jdbc_info[attr] == meta_data[attr]}
    end
    
    def rails_table_name
      unless @rails_table_name
        @rails_table_name = table_name.downcase
        @rails_table_name = @rails_table_name.pluralize if pluralize_table_name
      end
      @rails_table_name
    end
    
    def rails_table_name=(value)
      @rails_table_name = value
    end
    attr_accessor :rails_options
    
    def define_rails_model(mod)
      class_name = "Rails#{rails_table_name.classify}"
      class_def =  "class #{class_name} < ActiveRecord::Base\n"
      class_def << "  set_table_name('#{rails_table_name}')\n"
      class_def << "end"
      mod.module_eval(class_def)
      mod.const_get(class_name)
    end
    
    def define_jdbc_model(mod)
      class_name = "Jdbc#{table_name.classify}"
      class_def =  "class #{class_name} < ActiveRecord::Base\n"
      class_def << "  set_table_name('#{table_name}')\n"
      class_def << "  establish_connection('#{meta_data.source_db}')\n"
      class_def << "end"
      mod.module_eval(class_def)
      mod.const_get(class_name)
    end
    
    def [](column_name)
      column_name = column_name.to_s.upcase
      columns.detect{|col|col.name == column_name}
    end
  end
end
