require "rubeus/component_loader"

module Rubeus
  Jdbc = ComponentLoader.new("java.sql") do
    class_to_package.update(
      # $JAVA_HOME/lib/classlistにないものリスト
      'Connection' => 'java.sql', 
      'DriverManager' => 'java.sql', 
      'ResultSet' => 'java.sql', 
      'ResultSetMetaData' => 'java.sql', 
      'Statement' => 'java.sql'
      )
  end
end

require "rubeus/jdbc/closeable_resource"
require "rubeus/jdbc/column"
