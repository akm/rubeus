require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for Rubeus::Extensions::Javax::Swing
class TestJPanel < Test::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
  end

  # normal pattern
  def test_normal
    assert_nothing_raised do
      JFrame.new do |f|
        JPanel.new do |p|
          JButton.new("Push!")
        end
      end
    end
  end
end
