require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for nestable.rb
class TestNestable < Test::Unit::TestCase
  include Rubeus::Swing

  class TestClass
    include Rubeus::Awt::Nestable
  end

  # setup method
  def setup
  end

  # test for Nestable::Context#container_class_names=, register_as_container
  def atest_container_class_names=
    original_container_class_names = Rubeus::Awt::Nestable::Context.container_class_names

    Rubeus::Awt::Nestable::Context.container_class_names = "javax.swing.JTabbedPane"
    assert_equal(["javax.swing.JTabbedPane"], Rubeus::Awt::Nestable::Context.container_class_names)

    Rubeus::Awt::Nestable::Context.register_as_container "javax.swing.JPanel"
    assert_equal(["javax.swing.JTabbedPane", "javax.swing.JPanel"], Rubeus::Awt::Nestable::Context.container_class_names)

    Rubeus::Awt::Nestable::Context.container_class_names = *original_container_class_names
  end

  # test new with component
  def test_new_component
    assert_nothing_raised do
      JTextField.new
    end
  end

  # test new with block given component
  def test_new_block_given_component
    assert_nothing_raised do
      JTextField.new do |txt|
        # this block will ignore
        flunk "this statement does not executed"
      end
    end
  end

  # test new with container
  def test_new_container
    assert_nothing_raised do
      JPanel.new
    end
  end

  # test new with block given container
  def test_new_block_given_container
    is_block_executed = false

    JPanel.new do |p|
      is_block_executed = true
    end

    assert_equal(true, is_block_executed)
  end

  # test new container with component
  def test_new_container_with_component
    assert_nothing_raised do 
      JPanel.new do |p|
        txt = JTextField.new
      end
    end
  end

  # test new nested container with component
  def test_new_nested_container_with_component
    assert_nothing_raised do
      JPanel.new do |p|
        JScrollPane.new do |jsp|
          txt = JTextField.new
        end
        JLabel.new("test")
      end
    end
  end

  # test container?
  def test_container?
    assert_equal(true, JPanel.container?)
    assert_equal(false, JTextField.container?)
  end
end

