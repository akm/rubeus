# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubeus}
  s.version = "0.0.9"
  s.platform = %q{java}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["akimatter"]
  s.date = %q{2010-08-14}
  s.description = %q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
  s.email = %q{rubeus@googlegroups.com}
  s.executables = ["jirb_rubeus", "jirb_rubeus.bat"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/jirb_rubeus",
     "bin/jirb_rubeus.bat",
     "examples/.gitignore",
     "examples/JavaSwingExample01.java",
     "examples/jdbc_example.rb",
     "examples/notepad.rb",
     "examples/notepad.rtf",
     "examples/nyanco_viewer/nekobean_LICENSE.txt",
     "examples/nyanco_viewer/nekobean_s.png",
     "examples/nyanco_viewer/nyanco_disp_label.rb",
     "examples/nyanco_viewer/nyanco_viewer_rubeus.rb",
     "examples/rubeus_swing_example01.rb",
     "examples/rubeus_swing_example01_with_class.rb",
     "examples/rubeus_swing_example02.rb",
     "examples/rubeus_swing_example03.rb",
     "java/.gitignore",
     "java/mvn_plugins.yml",
     "java/pom.xml",
     "java/src/main/java/jp/rubybizcommons/rubeus/extensions/javax/swing/table/DelegatableTableModel.java",
     "java/src/main/java/jp/rubybizcommons/rubeus/extensions/javax/swing/table/ReadonlyableTableModel.java",
     "lib/rubeus.jar",
     "lib/rubeus.rb",
     "lib/rubeus/awt.rb",
     "lib/rubeus/awt/attributes.rb",
     "lib/rubeus/awt/event.rb",
     "lib/rubeus/awt/nestable.rb",
     "lib/rubeus/awt/setters.rb",
     "lib/rubeus/component_loader.rb",
     "lib/rubeus/extensions.rb",
     "lib/rubeus/extensions/java.rb",
     "lib/rubeus/extensions/java/awt.rb",
     "lib/rubeus/extensions/java/awt/component.rb",
     "lib/rubeus/extensions/java/awt/container.rb",
     "lib/rubeus/extensions/java/awt/dimension.rb",
     "lib/rubeus/extensions/java/lang.rb",
     "lib/rubeus/extensions/java/lang/reflect.rb",
     "lib/rubeus/extensions/java/lang/reflect/method.rb",
     "lib/rubeus/extensions/java/sql.rb",
     "lib/rubeus/extensions/java/sql/connection.rb",
     "lib/rubeus/extensions/java/sql/database_meta_data.rb",
     "lib/rubeus/extensions/java/sql/driver_manager.rb",
     "lib/rubeus/extensions/java/sql/result_set.rb",
     "lib/rubeus/extensions/java/sql/result_set_meta_data.rb",
     "lib/rubeus/extensions/java/sql/statement.rb",
     "lib/rubeus/extensions/javax.rb",
     "lib/rubeus/extensions/javax/swing.rb",
     "lib/rubeus/extensions/javax/swing/box_layout.rb",
     "lib/rubeus/extensions/javax/swing/j_applet.rb",
     "lib/rubeus/extensions/javax/swing/j_component.rb",
     "lib/rubeus/extensions/javax/swing/j_editor_pane.rb",
     "lib/rubeus/extensions/javax/swing/j_frame.rb",
     "lib/rubeus/extensions/javax/swing/j_list.rb",
     "lib/rubeus/extensions/javax/swing/j_panel.rb",
     "lib/rubeus/extensions/javax/swing/j_scroll_pane.rb",
     "lib/rubeus/extensions/javax/swing/j_split_pane.rb",
     "lib/rubeus/extensions/javax/swing/j_tabbed_pane.rb",
     "lib/rubeus/extensions/javax/swing/j_table.rb",
     "lib/rubeus/extensions/javax/swing/j_text_field.rb",
     "lib/rubeus/extensions/javax/swing/j_text_pane.rb",
     "lib/rubeus/extensions/javax/swing/j_window.rb",
     "lib/rubeus/extensions/javax/swing/table/default_table_model.rb",
     "lib/rubeus/extensions/javax/swing/table/readonlyable_table_model.rb",
     "lib/rubeus/extensions/javax/swing/timer.rb",
     "lib/rubeus/jdbc.rb",
     "lib/rubeus/jdbc/closeable_resource.rb",
     "lib/rubeus/jdbc/column.rb",
     "lib/rubeus/jdbc/foreign_key.rb",
     "lib/rubeus/jdbc/index.rb",
     "lib/rubeus/jdbc/meta_element.rb",
     "lib/rubeus/jdbc/primary_key.rb",
     "lib/rubeus/jdbc/result_set_column.rb",
     "lib/rubeus/jdbc/table.rb",
     "lib/rubeus/reflection.rb",
     "lib/rubeus/swing.rb",
     "lib/rubeus/util.rb",
     "lib/rubeus/util/java_method_name.rb",
     "lib/rubeus/util/name_access_array.rb",
     "lib/rubeus/verboseable.rb",
     "rmaven.yml",
     "rubeus.gemspec",
     "test/rubeus/awt/test_attributes.rb",
     "test/rubeus/awt/test_event.rb",
     "test/rubeus/awt/test_nestable.rb",
     "test/rubeus/awt/test_setter.rb",
     "test/rubeus/extensions/java/awt/test_dimension.rb",
     "test/rubeus/extensions/java/sql/test_connection.rb",
     "test/rubeus/extensions/java/sql/test_database_meta_data.rb",
     "test/rubeus/extensions/java/sql/test_driver_manager.rb",
     "test/rubeus/extensions/java/sql/test_result_set.rb",
     "test/rubeus/extensions/java/sql/test_result_set_meta_data.rb",
     "test/rubeus/extensions/java/sql/test_sql_helper.rb",
     "test/rubeus/extensions/java/sql/test_statement.rb",
     "test/rubeus/extensions/javax/swing/table/test_default_table_model.rb",
     "test/rubeus/extensions/javax/swing/table/test_default_table_model/nhk_words.xml",
     "test/rubeus/extensions/javax/swing/test_box_layout.rb",
     "test/rubeus/extensions/javax/swing/test_j_component.rb",
     "test/rubeus/extensions/javax/swing/test_j_frame.rb",
     "test/rubeus/extensions/javax/swing/test_j_panel.rb",
     "test/rubeus/extensions/javax/swing/test_j_scroll_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_split_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_tabbed_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_table.rb",
     "test/rubeus/extensions/javax/swing/test_j_text_field.rb",
     "test/rubeus/extensions/javax/swing/test_timer.rb",
     "test/rubeus/reflection/test_method_modifier.rb",
     "test/rubeus/test_extensions.rb",
     "test/rubeus_test.jar",
     "test/test_all.rb",
     "test_jar/.classpath",
     "test_jar/.gitignore",
     "test_jar/.project",
     "test_jar/mvn_plugins.yml",
     "test_jar/pom.xml",
     "test_jar/src/main/java/jp/rubybizcommons/rubeus/test/reflection/VariousFields.java",
     "test_jar/src/main/java/jp/rubybizcommons/rubeus/test/reflection/VariousMethods.java",
     "test_jar/src/test/java/jp/rubybizcommons/rubeus/test/AppTest.java"
  ]
  s.homepage = %q{http://code.google.com/p/rubeus/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
  s.test_files = [
     "test/rubeus/test_extensions.rb",
     "test/rubeus/awt/test_attributes.rb",
     "test/rubeus/awt/test_event.rb",
     "test/rubeus/awt/test_nestable.rb",
     "test/rubeus/awt/test_setter.rb",
     "test/rubeus/extensions/java/awt/test_dimension.rb",
     "test/rubeus/extensions/java/sql/test_connection.rb",
     "test/rubeus/extensions/java/sql/test_database_meta_data.rb",
     "test/rubeus/extensions/java/sql/test_driver_manager.rb",
     "test/rubeus/extensions/java/sql/test_result_set.rb",
     "test/rubeus/extensions/java/sql/test_result_set_meta_data.rb",
     "test/rubeus/extensions/java/sql/test_sql_helper.rb",
     "test/rubeus/extensions/java/sql/test_statement.rb",
     "test/rubeus/extensions/javax/swing/test_box_layout.rb",
     "test/rubeus/extensions/javax/swing/test_j_component.rb",
     "test/rubeus/extensions/javax/swing/test_j_frame.rb",
     "test/rubeus/extensions/javax/swing/test_j_panel.rb",
     "test/rubeus/extensions/javax/swing/test_j_scroll_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_split_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_tabbed_pane.rb",
     "test/rubeus/extensions/javax/swing/test_j_table.rb",
     "test/rubeus/extensions/javax/swing/test_j_text_field.rb",
     "test/rubeus/extensions/javax/swing/test_timer.rb",
     "test/rubeus/extensions/javax/swing/table/test_default_table_model.rb",
     "test/rubeus/reflection/test_method_modifier.rb",
     "examples/jdbc_example.rb",
     "examples/notepad.rb",
     "examples/rubeus_swing_example01.rb",
     "examples/rubeus_swing_example01_with_class.rb",
     "examples/rubeus_swing_example02.rb",
     "examples/rubeus_swing_example03.rb",
     "examples/nyanco_viewer/nyanco_disp_label.rb",
     "examples/nyanco_viewer/nyanco_viewer_rubeus.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 2.1.2"])
      s.add_development_dependency(%q<rcov>, [">= 0.9.8"])
    else
      s.add_dependency(%q<activesupport>, ["= 2.1.2"])
      s.add_dependency(%q<rcov>, [">= 0.9.8"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 2.1.2"])
    s.add_dependency(%q<rcov>, [">= 0.9.8"])
  end
end

