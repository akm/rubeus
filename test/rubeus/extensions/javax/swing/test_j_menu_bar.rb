require 'minitest_helper'

# Test for j_menu_bar.rb
class TestJMenuBar < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    assert_nothing_raised do
      JFrame.new do |f|
        menubar = JMenuBar.new do
          JMenu.new("File") do
            JMenuItem.new("New...") do
            end
            JMenuItem.new("Exit") do
            end
          end
        end

        f.jmenu_bar = menubar
      end
    end
  end
end
