# -*- coding: utf-8 -*-
Rubeus::Jdbc.depend_on("Connection")

module Rubeus::Extensions::Java::Sql
  module DriverManager
    def self.included(base)
      base.extend ClassMethods
      base.extend Rubeus::Jdbc::CloseableResource
    end

    module ClassMethods
      CONNECT_DEFAULT_OPTIONS = {
        :auto_setup_manager => true # trueならconnectメソッドの引数urlからドライバを探してロードします
      }.freeze

      def connect(url, user = '', password = '', options = CONNECT_DEFAULT_OPTIONS, &block)
        setup_for(url, options) if options[:auto_setup_manager]
        with_close(get_connection(url, user, password), &block)
      end

      def setup_for(url, options = nil)
        DriverManager::Loader.setup_for(url, options)
      end
    end

    class Loader
      class << self
        def entries
          @entries ||= []
        end

        def entry(name, *args, &block)
          result = self.new(name)
          if block_given?
            result.instance_eval(&block)
          else
            pattern, driver, driver_type, options = *args
            result.instance_eval do |db|
              db.pattern(pattern, driver, driver_type || :unknown)
              db.options = options
            end
          end
          entries << result
          result
        end

        def setup_for(url, setup_options = nil)
          entries.each do |entry|
            driver = entry.setup_for(url, setup_options)
            return driver if driver
          end
          raise ArgumentError, "DriverManager catalog not found for #{url}"
        end
      end

      attr_reader :name, :patterns

      def initialize(name)
        @name = name
        @patterns = []
      end

      def pattern(pattern, driver, driver_type = :unknown)
        @patterns << {:pattern => pattern, :driver => driver, :driver_type => driver_type}
      end

      def options
        @options ||= {}
      end

      def options=(value)
        @options = value
      end

      def driver_for(url, driver_type = nil)
        patterns = driver_type ? @patterns.select{|pattern| pattern[:driver_type] == driver_type} : @patterns
        pattern = patterns.detect{|pattern| pattern[:pattern] =~ url}
        pattern ? pattern[:driver] : nil
      end

      def setup_for(url, setup_options = nil)
        driver_name = driver_for(url)
        return nil unless driver_name
        begin
          return JavaUtilities.get_proxy_class(driver_name)
        rescue NameError => name_error
          requirements = options[:gem_require]
          raise name_error unless requirements
          requirements = [requirements] unless requirements.is_a?(Array)
          load_error_messages = []
          requirements.each do |requirement|
            begin
              require(requirement)
            rescue LoadError => load_error
              msg = "failure to load '#{requirement}' of '#{options[:gem]}'."
              msg << " Try 'jruby -S gem install #{options[:gem]}'" unless /\.jar$/ =~ requirement
              load_error_messages << msg
              next
            end
            begin
              return JavaUtilities.get_proxy_class(driver_name)
            rescue NameError => name_error_again
              msg = "#{driver_name} not found for #{url}"
              msg << ", but loaded '#{requirement}' of '#{options[:gem]}' successfully."
              msg << " It might be a serious problem. Please let us know by email '#{Rubeus::EMAIL_GROUP}'. "
              raise NameError, msg
            end
          end
          raise LoadError, "#{driver_name} not found for #{url} because of " << load_error_messages.join(" AND ")
        end
      end
    end

    # http://wiki.paulownia.jp/java/jdbc
    class Loader
      # JDBC-ODBC Bridge
      # (Type1) sun.jdbc.odbc.JdbcOdbcDriver
      # jdbc:odbc:DataSourceName
      # Type1はODBCを使用してデータベースにアクセス。ODBCドライバのインストールと
      # ODBCアドミニストレータ設定が必要。DataSourceNameにはODBCで設定した名前を入れる。
      entry("ODBC", /^jdbc:odbc:/, "sun.jdbc.odbc.JdbcOdbcDriver", :type1)

      # DB2
      # Type2  COM.ibm.db2.jdbc.app.DB2Driver (v8.1まで)
      # com.ibm.db2.jcc.DB2Driver (DB2 v8.1.2以降)
      # jdbc:db2:DataSourceName
      # DB2クライアントのインストールが必要。DataSourceNameには、DB2構成アシスタントで
      # 設定したデータソース名を記述する。新しいドライバはType4と同じクラスで、URLでどちらのTypeを使うか区別する。
      #
      # DB2
      # Type3 COM.ibm.db2.jdbc.net.DB2Driver
      # jdbc:db2://127.0.0.1:50000/DataBaseName
      # JDBC Type3ドライバのサポートは終了しており、Type4の使用が推奨されている。
      #
      # DB2
      # Type4 com.ibm.db2.jcc.DB2Driver
      # jdbc:db2://127.0.0.1:50000/DataBaseName
      # DB2バージョン8.1からサポートされた。DB2クライアントのインストールは不要。
      entry "DB2" do |db|
        db.pattern(/^jdbc:db2:/, 'com.ibm.db2.jcc.DB2Driver'     , :type4)
        db.pattern(/^jdbc:db2:/, 'COM.ibm.db2.jdbc.net.DB2Driver', :type3)
        db.pattern(/^jdbc:db2:/  , 'COM.ibm.db2.jdbc.app.DB2Driver', :type2)
      end

      # Oracle
      # Type4 oracle.jdbc.driver.OracleDriver
      # jdbc:oracle:thin:@127.0.0.1:1521:SID
      # オラクルは他のDBと違い、URLのプロトコルとホストの区切りが // ではなく @ となっている。
      #
      # Oracle
      # Type2 oracle.jdbc.driver.OracleDriver
      # jdbc:oracle:oci8:@TNS (for Oracle 8i)
      # jdbc:oracle:oci:@TNS (for Oracle 9i or 10g)
      # tnsnames.oraファイルにデータソースの設定を書く。Oracleクライアントが必要。
      # 10gは9i用クライアントでも使用可能のようだ。
      entry "Oracle" do |db|
        db.pattern(/^jdbc:oracle:thin:@/, 'oracle.jdbc.driver.OracleDriver', :type4)
        db.pattern(/^jdbc:oracle:oci8:@/, 'oracle.jdbc.driver.OracleDriver', :type2)
        db.pattern(/^jdbc:oracle:oci:@/ , 'oracle.jdbc.driver.OracleDriver', :type2)
      end

      # SQL Server 2000
      # Type4  com.microsoft.jdbc.sqlserver.SQLServerDriver
      # jdbc:microsoft:sqlserver://127.0.0.1:1433;DatabaseName=DBName
      # MS製なのでWindows版しかないが、導入が容易でバランスのとれたチューニングが施されている。
      # このドライバはMSDE 2000でも使用可能。
      entry("SQL Server 2000", /^jdbc:microsoft:sqlserver:/, "com.microsoft.jdbc.sqlserver.SQLServerDriver", :type4)

      # SQL Server 2005
      # Type4  com.microsoft.sqlserver.jdbc.SQLServerDriver
      # jdbc:sqlserver://localhost:1433;DatabaseName=DBName
      # SQLServer 2005。旧バージョンからドライバクラスもURLも微妙に変更されているので注意。参考
      entry("SQL Server 2005", /^jdbc:sqlserver:/, "com.microsoft.sqlserver.jdbc.SQLServerDriver", :type4)

      # Firebird
      # Type 4  org.firebirdsql.jdbc.FBDriver
      # jdbc:firebirdsql://127.0.0.1:3050/DataBasePath
      # オープンソースのRDB。DataBasePathにはサーバ上のデータベースファイル(.gdb)への絶対パスを指定するらしい。
      entry("Firebird", /^jdbc:firebirdsql:/, "org.firebirdsql.jdbc.FBDriver", :type4)

      # MySQL
      # Type 4  com.mysql.jdbc.Driver
      # jdbc:mysql://127.0.0.1:3306/DBName
      # GPLライセンスと商用ライセンスで利用できるRDB。Movable Type等のBlogツールでも採用されている。
      entry("MySQL", /^jdbc:mysql:/, "com.mysql.jdbc.Driver", :type4,
        :gem => "jdbc-mysql", :gem_require => "jdbc/mysql")

      # PostgreSQL
      # Type 4  org.postgresql.Driver
      # jdbc:postgresql://127.0.0.1:5432/DBName
      # BSDライセンスで配布されており、商用でも無償で使用可能。中小規模システム、個人用DBとしてMySQLと並んで人気。
      entry("PostgreSQL", /^jdbc:postgresql:/, "org.postgresql.Driver", :type4,
        :gem => "jdbc-postgres", :gem_require => "jdbc/postgres")

      # HSQLDB  org.hsqldb.jdbcDriver
      # jdbc:hsqldb:hsql://127.0.0.1:9001/databasename
      # 高速、軽量、Pure Javaの組み込み向けRDBMS。jarファイル一つで動作する。このURLはサーバモードで起動したHSQLDBにアクセスするURL。
      #
      # org.hsqldb.jdbcDriver
      # jdbc:hsqldb:file:databasename
      # HSQLDBをインプロセスモードで起動する。javaアプリケーションと同じVM上で起動し、組み込みのデータベースとして使う。
      # 終了時にSHUTDOWN命令を送らないとデータが永続化されない。URLの最後に;shutdown=trueを付加すると終了時にデータが自動的に保存される。
      #
      # org.hsqldb.jdbcDriver
      # jdbc:hsqldb:mem:databasename
      # HSQLDBをインメモリモードで起動する。インメモリモードはスタンドアロンモードと同じだがデータを永続化しない。JavaVMを終了するとデータが失われる。
      entry "HSQLDB" do |db|
        db.pattern(/^jdbc:hsqldb:hsql:/, "org.hsqldb.jdbcDriver")
        db.pattern(/^jdbc:hsqldb:file:/, "org.hsqldb.jdbcDriver")
        db.pattern(/^jdbc:hsqldb:mem:/ , "org.hsqldb.jdbcDriver")
        db.options = {:gem => "jdbc-hsqldb", :gem_require => "jdbc/hsqldb"}
      end

      # Derby  org.apache.derby.jdbc.EmbeddedDriver
      # jdbc:derby:databasename;create=true
      # Java言語で書かれた組み込み用のデータベース。create=trueはオプションで、databasenameが見つからない場合に新規データベースを作成する。
      entry("Derby", /^jdbc:derby:/, "org.apache.derby.jdbc.EmbeddedDriver", :unknown,
        :gem => 'jdbc-derby', :gem_require => [
          'jdbc/derby',
          (ENV_JAVA['java.specification.version'] > '1.5' ? File.join(ENV_JAVA['java.home'], 'db', 'lib', 'derby.jar') : nil)
        ].compact)

      # OpenBase
      # Type4  com.openbase.jdbc.ObDriver
      # jdbc:openbase://localhost/DataBaseName
      # MacOSXの前身NEXTSTEP/OPENSTEP上で開発されたRDBMSらしい。Linux版、Windows版もあるようだ。
      entry("OpenBase", /^jdbc:openbase:/, "com.openbase.jdbc.ObDriver", :type4)

      # H2   org.h2.Driver
      # jdbc:h2:tcp://localhost:9092/DataBasePath
      # HSQLの開発者が作成した組み込みDB。DBをサーバとして起動した場合のURL。
      # org.h2.Driver
      # jdbc:h2:DataBasePath
      # 組み込みDBとして使用する場合のURL。
      entry "H2" do |db|
        db.pattern(/^jdbc:h2:tcp:/, "org.h2.Driver")
        db.pattern(/^jdbc:h2:/    , "org.h2.Driver")
        db.options = {:gem => "jdbc-h2", :gem_require => "jdbc/h2"}
      end

      # Sybase ASE
      # Type4  com.sybase.jdbc.SybDriver
      # jdbc:sybase:Tds:localhost:8001/databasename
      # 一時期MSSQLServerとして提供されていたこともあるRDBMS。そのためか両製品をサポートしているサードパーティ製やオープンソースのドライバがある。
      entry("Sybase ASE", /^jdbc:sybase:Tds:/, "com.sybase.jdbc.SybDriver", :type4)

      # SQLite
      # Type4(?)  org.sqlite.JDBC
      # jdbc:sqlite:databasefile_path
      # SQLiteにアクセスするJDBCドライバ。NestedVMというものをつかってPure Javaのドライバとしている？らしい…
      entry("SQLite", /^jdbc:sqlite:/, "org.sqlite.JDBC", :type4,
        :gem => "jdbc-sqlite3", :gem_require => "jdbc/sqlite3")
    end

  end
end
