require 'java'
require 'rubygems'
require 'rubeus'

def setup_derby
  return if ENV_JAVA['java.class.path'].split(File::PATH_SEPARATOR).any?{|path| /derby[\-\.\d]*\.jar$/ =~ path}
  if ENV_JAVA["java.specification.version"] == "1.6"
    begin
      require File.join(ENV_JAVA['java.home'], 'db', 'lib', 'derby.jar')
      return
    rescue LoadError
      # ignore error if not installed JavaDB
      # Apple's JDK doesn't include Apache Derby
    end
  end
  puts "JavaDB is not installed."
  puts "Please add derby.jar to your CLASSPATH."
end

setup_derby

class JdbcExample
  include Rubeus::Jdbc

  def initialize
    # Register Driver
    Java::OrgApacheDerbyJdbc::EmbeddedDriver
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

        # Query by each_array
        stmt.query("SELECT * FROM TEST") do |rs|
          rs.each_array do |rsNext|
            print "|", rsNext[0], "|", rsNext[1], "|\n"
          end
        end

        # Connection#query by each_hash
        con.query("SELECT * FROM TEST") do |rs|
          rs.each_hash do |rsNext|
            print "|", rsNext["ID"], "|", rsNext["DATA"], "|\n"
          end
        end

      end
    end
  end
end

JdbcExample.new.test
