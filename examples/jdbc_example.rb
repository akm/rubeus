require 'java'
require 'rubygems'
require 'rubeus'

if ENV_JAVA["java.specification.version"] == "1.6"
  begin
    require java.lang.System.getenv("JAVA_HOME") + "/db/lib/derby.jar"
  rescue LoadError
    # ignore error if not installed JavaDB
    puts "JavaDB is not installed."
    puts "Please add derby.jar to your CLASSPATH."
  end
end

class JdbcExample
  include Rubeus::Jdbc

  def initialize
    # Register Driver
    Java::OrgApacheDerbyJdbc::EmbeddedDriver.new
  end

  def test
    DriverManager.connect("jdbc:derby:test;create = true", "", "") do |con|
      con.statement do |stmt|
        # Drop table TEST if exists
        begin
          stmt.execute_update("DROP TABLE TEST")
        rescue
          # ignore error if table not exist
        end

        # Setup table and data
        stmt.execute_update("CREATE TABLE TEST(id int, data char(10))")
        stmt.execute_update("INSERT INTO TEST VALUES(1, 'first')")
        stmt.execute_update("INSERT INTO TEST VALUES(2, 'second')")

        # Query
        stmt.query("SELECT * FROM TEST") do |rs|
          rs.each do |rsNext|
            print "|", rsNext.getInt("ID"), "|", rsNext.getString("DATA"), "|\n"
          end
        end
      end
    end
  end
end

JdbcExample.new.test
