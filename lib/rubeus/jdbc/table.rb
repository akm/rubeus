# -*- coding: utf-8 -*-
require 'rubeus/jdbc/meta_element'
require "rubeus/jdbc/column"
require "rubeus/jdbc/index"
require "rubeus/jdbc/primary_key"
require "rubeus/jdbc/foreign_key"
module Rubeus::Jdbc
  class Table < MetaElement
    include FullyQualifiedNamed

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
    attr_accessor :table_type,
    :remarks, :type_cat, :type_schem, :type_name,
    :self_referencing_col_name, :ref_generation

    attr_accessor :pluralize_table_name
    attr_accessor :columns

    def inspect
      "#<#{self.class} #{name}(%s)>" % columns.map(&:name).join(',')
    end

    def name
      self.table_name.send(options[:name_case] || :to_s)
    end

    def [](column_name)
      column_name = column_name.to_s.upcase
      columns.detect{|col|col.column_name.upcase == column_name}
    end

    def primary_key
      unless defined?(@primary_keys)
        pk_records = meta_data.getPrimaryKeys(table_cat, table_schem, table_name).
          map{|r| r.to_hash}.
          select{|hash|self.same_fqn?(hash)}.
          sort_by{|record| record['KEY_SEQ']}
        if pk_records.empty?
          @primary_key = nil
        else
          @primary_key = Rubeus::Jdbc::PrimaryKey.new(meta_data, self, {
              :pk_name => pk_records.map{|record| record['PK_NAME']}.uniq.first,
              :column_names => pk_records.map{|record| record['COLUMN_NAME'].
                send(options[:name_case] || :to_s)}
            },
            options)
        end
      end
      @primary_key
    end
    alias_method :pk, :primary_key

    def primary_key_names
      primary_key ? primary_key.column_names : []
    end
    alias_method :pk_names, :primary_key_names

    def primary_key_columns
      primary_key ? primary_key.columns : []
    end
    alias_method :pk_columns, :primary_key_columns

    def self.singular_access_if_possible(method_name, plural_method)
      define_method(method_name) do
        values = self.send(plural_method)
        (values.nil? || values.empty?) ? nil :
          (values.length == 1) ? values.first : values
      end
    end

    singular_access_if_possible(:pk_name, :pk_names)
    singular_access_if_possible(:pk_column, :pk_columns)
    singular_access_if_possible(:primary_key_name, :primary_key_names)
    singular_access_if_possible(:primary_key_column, :primary_key_columns)

    def indexes
      unless @indexes
        @indexes = Rubeus::Util::NameAccessArray.new
        index_infos = meta_data.getIndexInfo(table_cat, table_schem, table_name, false, true).map{|r| r.to_hash}
        index_hash = {}
        index_infos.each do |index_info|
          index_uniq_key = Rubeus::Jdbc::Index::RECORD_UNIQUE_ATTRS.
            map{|attr| attr.to_s}.map{|attr| attr.upcase}.map{|key| index_info[key]}
          unless index_hash[index_uniq_key]
            attrs = Rubeus::Jdbc::Index::ATTR_NAMES.map{|attr| attr.to_s}.
              inject({}){|dest, name| dest[name.downcase] = index_info[name.upcase]; dest}
            index = Rubeus::Jdbc::Index.new(meta_data, self, attrs, options)
            @indexes << index
            index_hash[index_uniq_key] = index
          end
        end
        index_infos.each do |index_info|
          index_uniq_key = Rubeus::Jdbc::Index::RECORD_UNIQUE_ATTRS.
            map{|attr| attr.to_s}.map{|attr| attr.upcase}.map{|key| index_info[key]}
          index = index_hash[index_uniq_key]
          attrs = Rubeus::Jdbc::Index::Key::ATTR_NAMES.map{|attr| attr.to_s}.
            inject({}){|dest, name| dest[name.downcase] = index_info[name.upcase]; dest}
          index.keys << Rubeus::Jdbc::Index::Key.new(meta_data, index, attrs, options)
        end
      end
      @indexes
    end

    IMPORTED_KEY_UNIQUE_ATTRS = %w(PKTABLE_CAT PKTABLE_SCHEM PKTABLE_NAME FK_NAME)

    def imported_keys
      unless @imported_keys
        @imported_keys = Rubeus::Util::NameAccessArray.new
        imported_key_hash = {}
        imported_keys = meta_data.getImportedKeys(table_cat, table_schem, table_name).map{|r| r.to_hash}
        imported_keys.each do |imported_key|
          unique_key = IMPORTED_KEY_UNIQUE_ATTRS.map{|attr| imported_key[attr]}
          unless imported_key_hash[unique_key]
            attrs = Rubeus::Jdbc::ForeignKey::ATTR_NAMES.map{|attr| attr.to_s}.
              inject({}){|dest, name| dest[name.downcase] = imported_key[name.upcase]; dest}
            foreign_key = Rubeus::Jdbc::ForeignKey.new(meta_data, self, attrs, options)
            foreign_key.fktable = self
            foreign_key.pktable = meta_data.table_object(imported_key['PKTABLE_NAME'],
              :catalog => imported_key['PKTABLE_CAT'], :schema => imported_key['PKTABLE_SCHEM'])
            @imported_keys << foreign_key
            imported_key_hash[unique_key] = foreign_key
          end
        end
        imported_keys.each do |imported_key|
          unique_key = IMPORTED_KEY_UNIQUE_ATTRS.map{|attr| imported_key[attr]}
          foreign_key = imported_key_hash[unique_key]
          foreign_key.fkcolumn_names ||= []
          foreign_key.pkcolumn_names ||= []
          foreign_key.fkcolumn_names << imported_key['FKCOLUMN_NAME'].send(options[:name_case] || :to_s)
          foreign_key.pkcolumn_names << imported_key['PKCOLUMN_NAME'].send(options[:name_case] || :to_s)
        end
      end
      @imported_keys
    end
    alias_method :foreign_keys, :imported_keys
    alias_method :fks, :imported_keys

    EXPORTED_KEY_UNIQUE_ATTRS = %w(FKTABLE_CAT FKTABLE_SCHEM FKTABLE_NAME PK_NAME)

    def exported_keys
      unless @exported_keys
        @exported_keys = Rubeus::Util::NameAccessArray.new
        exported_key_hash = {}
        exported_keys = meta_data.getExportedKeys(table_cat, table_schem, table_name).map{|r| r.to_hash}
        exported_keys.each do |exported_key|
          unique_key = EXPORTED_KEY_UNIQUE_ATTRS.map{|attr| exported_key[attr]}
          unless exported_key_hash[unique_key]
            attrs = Rubeus::Jdbc::ForeignKey::ATTR_NAMES.map{|attr| attr.to_s}.
              inject({}){|dest, name| dest[name.downcase] = exported_key[name.upcase]; dest}
            foreign_key = Rubeus::Jdbc::ForeignKey.new(meta_data, self, attrs, options)
            foreign_key.fktable = meta_data.table_object(exported_key['FKTABLE_NAME'],
              :catalog => exported_key['FKTABLE_CAT'], :schema => exported_key['FKTABLE_SCHEM'])
            foreign_key.pktable = self
            @exported_keys << foreign_key
            exported_key_hash[unique_key] = foreign_key
          end
        end
        exported_keys.each do |exported_key|
          unique_key = EXPORTED_KEY_UNIQUE_ATTRS.map{|attr| exported_key[attr]}
          foreign_key = exported_key_hash[unique_key]
          foreign_key.fkcolumn_names ||= []
          foreign_key.pkcolumn_names ||= []
          foreign_key.fkcolumn_names << exported_key['FKCOLUMN_NAME'].send(options[:name_case] || :to_s)
          foreign_key.pkcolumn_names << exported_key['PKCOLUMN_NAME'].send(options[:name_case] || :to_s)
        end
      end
      @exported_keys
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

  end
end
