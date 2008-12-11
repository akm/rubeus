# -*- coding: utf-8 -*-
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
    
    def self.irb
      self.extend_with
    end
  end
end

require "rubeus/jdbc/closeable_resource"
require "rubeus/jdbc/result_set_column"
