# -*- coding: utf-8 -*-
module Rubeus::Jdbc
  class ForeignKey < TableElement
    #   1. PKTABLE_CAT String => インポートされた主キーテーブルカタログ (null の可能性がある)
    #   2. PKTABLE_SCHEM String => インポートされた主キーテーブルスキーマ (null の可能性がある)
    #   3. PKTABLE_NAME String => インポートされた主キーテーブル名
    #   4. PKCOLUMN_NAME String => インポートされた主キー列名
    #   5. FKTABLE_CAT String => 外部キーテーブルカタログ (null の可能性がある)
    #   6. FKTABLE_SCHEM String => 外部キーテーブルスキーマ (null の可能性がある)
    #   7. FKTABLE_NAME String => 外部キーテーブル名
    #   8. FKCOLUMN_NAME String => 外部キー列名
    #   9. KEY_SEQ short => 外部キー中の連番
    #  10. UPDATE_RULE short => 主キーが更新されるときに、外部キーに起こる内容は次のとおりである
    #          * importedNoAction - 主キーがインポートされたら、更新できない
    #          * importedKeyCascade - 主キーの更新に合致するように、インポートされたキーを変更する
    #          * importedKeySetNull - インポートされたキーの主キーが更新されたら、NULL に変更する
    #          * importedKeySetDefault - インポートされたキーの主キーが更新されたら、デフォルト値に変更する
    #          * importedKeyRestrict - importedKeyNoAction と同じ (ODBC 2.x との互換性のため)
    #  11. DELETE_RULE short => 主キーが削除されると、外部キーに起こる内容は次のとおりである
    #          * importedKeyNoAction - 主キーがインポートされたら、削除できない
    #          * importedKeyCascade - 削除されたキーをインポートする行を、削除する
    #          * importedKeySetNull - インポートされたキーの主キーが削除されたら、NULL に変更する
    #          * importedKeyRestrict - importedKeyNoAction と同じ (ODBC 2.x との互換性のため)
    #          * importedKeySetDefault - インポートされたキーの主キーが削除されたら、デフォルト値に変更する
    #  12. FK_NAME String => 外部キー名 (null の可能性がある)
    #  13. PK_NAME String => 主キー名 (null の可能性がある)
    #  14. DEFERRABILITY short => 外部キーの制限の評価はコミットまで延期できる
    #          * importedKeyInitiallyDeferred - 定義については SQL92 を参照
    #          * importedKeyInitiallyImmediate - 定義については SQL92 を参照
    #          * importedKeyNotDeferrable - 定義については SQL92 を参照
    #
    # see also:
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getExportedKeys(java.lang.String,%20java.lang.String,%20java.lang.String)
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getImportedKeys(java.lang.String,%20java.lang.String,%20java.lang.String)

    ATTR_NAMES = [:pktable_cat, :pktable_schem, :pktable_name, # :pkcolumn_name,
      :fktable_cat, :fktable_schem, :fktable_name, # :fkcolumn_name,
      :key_seq, :update_rule, :delete_rule, :fk_name, :pk_name, :deferrability]
    attr_accessor *ATTR_NAMES

    attr_accessor :fkcolumn_names, :pkcolumn_names
    attr_accessor :fktable, :pktable

    def inspect
      "#<#{self.class.name} #{name} #{fktable.name}(%s)=>#{pktable.name}(%s)>" %
        [fkcolumn_names.join(','), pkcolumn_names.join(',')]
    end

    def name
      fk_name.send(options[:name_case] || :to_s)
    end

    def pretty_print_instance_variables
      super - [:@fktable, :@pktable]
    end

    def length
      pkcolumn_names.length
    end
    alias_method :size, :length

    def fkcolumns
      @fkcolumns ||= fkcolumn_names.map{|name| fktable.columns[name]}
    end

    def pkcolumns
      @pkcolumns ||= pkcolumn_names.map{|name| pktable.columns[name]}
    end

  end
end
