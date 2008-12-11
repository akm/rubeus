# -*- coding: utf-8 -*-
module Rubeus::Jdbc
  class ImportedKey < MetaElement
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
    # http://java.sun.com/javase/ja/6/docs/ja/api/java/sql/DatabaseMetaData.html#getImportedKeys(java.lang.String,%20java.lang.String,%20java.lang.String)
    #
    attr_accessor :pktable_cat, :pktable_schem, :pktable_name, :pkcolumn_name,
    :fktable_cat, :fktable_schem, :fktable_name, :fkcolumn_name,
    :key_seq, :update_rule, :delete_rule, :fk_name, :pk_name, :deferrability
    
    attr_reader :table
    alias_method :fktable, :table
    attr_accessor :pktable

    def initialize(meta_data, table, *args, &block)
      super(meta_data, *args, &block)
      @table = table
    end

    def pretty_print_instance_variables
      super - [:@table, :@fktable, :@pktable]
    end
  end
end
