require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for j_tabbed_pane.rb
class TestJTabbedPane < Test::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # test for original constructors
  def test_original_constructors
    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::TOP) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::BOTTOM) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::LEFT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::RIGHT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::TOP, javax.swing.JTabbedPane::WRAP_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::BOTTOM, javax.swing.JTabbedPane::SCROLL_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::LEFT, javax.swing.JTabbedPane::WRAP_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(javax.swing.JTabbedPane::RIGHT, javax.swing.JTabbedPane::SCROLL_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end
  end

  # test for constructors with symbol
  def test_constructors_with_symbol
    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:TOP) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:BOTTOM) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:LEFT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:RIGHT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:TOP, :WRAP_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:BOTTOM, :SCROLL_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:LEFT, :WRAP_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end

    assert_nothing_raised do
      JFrame.new do |f|
        JTabbedPane.new(:RIGHT, :SCROLL_TAB_LAYOUT) do
          JButton.new
          JLabel.new("JTabbedPane test")
        end
      end
    end
  end

  # test for setter utilities
  def test_setter_utilities
    JFrame.new do |f|
      JTabbedPane.new do |tp|
        JButton.new
        JLabel.new("JTabbedPane test")

        tp.set_titles(["Title1", "Title2"])
tp.set_icons([File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "examples", "nyanco_viewer", "nekobean_s.png"), ""])
#        tp.set_icons([File.join("..", "..", "..", "..", "..", "examples", "nyanco_viewer", "nekobean_s.png"), ""])
        tp.set_tips(["Tip1", "Tip2"])

        assert_equal(2, tp.tab_count)
        assert_equal("Title1", tp.get_title_at(0))
        assert_equal("Title2", tp.get_title_at(1))
        assert_equal(32, tp.get_icon_at(0).icon_height)
        assert_equal(32, tp.get_icon_at(0).icon_width)
        assert_nil(tp.get_icon_at(1))
        assert_equal("Tip1", tp.get_tool_tip_text_at(0))
        assert_equal("Tip2", tp.get_tool_tip_text_at(1))
      end
    end
  end
end

