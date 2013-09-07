require 'minitest_helper'
# Rubeus.verbose = true

# Test for extensions.rb
class TestExtensions < MiniTest::Unit::TestCase
  # setup method
  def setup
  end

  # test path_for
  def test_path_for
    # java fqn
    assert_equal("rubeus/extensions/javax/swing/j_table", Rubeus::Extensions.path_for("javax.swing.JTable"))
    assert_equal("rubeus/extensions/javax/swing/j_tabbed_pane", Rubeus::Extensions.path_for("javax.swing.JTabbedPane"))

    # parts
    assert_equal("rubeus/extensions/javax/swing/j_table", Rubeus::Extensions.path_for(["javax", "swing", "JTable"]))
    assert_equal("rubeus/extensions/javax/swing/j_tabbed_pane", Rubeus::Extensions.path_for(["javax", "swing", "JTabbedPane"]))
  end

  # test class_name_for
  def test_class_name_for
    # java fqn
    assert_equal("Rubeus::Extensions::Javax::Swing::JTable", Rubeus::Extensions.class_name_for("javax.swing.JTable"))
    assert_equal("Rubeus::Extensions::Javax::Swing::JTabbedPane", Rubeus::Extensions.class_name_for("javax.swing.JTabbedPane"))

    # parts
    assert_equal("Rubeus::Extensions::Javax::Swing::JTable", Rubeus::Extensions.class_name_for(["javax", "swing", "JTable"]))
    assert_equal("Rubeus::Extensions::Javax::Swing::JTabbedPane", Rubeus::Extensions.class_name_for(["javax", "swing", "JTabbedPane"]))
  end

  # test find_for
  def test_find_for
    # normal
    Rubeus::Extensions.find_for("javax.swing.JTable")

    # LoadError
    assert_nil(Rubeus::Extensions.find_for("javax.swing.DoesNotExistClass"))
  end
end
