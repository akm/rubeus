require 'rubygems'
require 'rubeus'

class JTabbedPaneExample
  include Rubeus::Swing

  def initialize
    JFrame.new(:title => 'JTabbedPane Example') do |f|
      tp = JTabbedPane.new(:LEFT, :SCROLL_TAB_LAYOUT) do |tp|
        # tab #1
        JSplitPane.new(:HORIZONTAL_SPLIT) do
          JButton.new("button") do
            javax.swing.JOptionPane.showMessageDialog(f, "button pushed!")
            tp.set_selected_index(1)
          end
          JLabel.new("<- Push this button.")
        end

        # tab #2
        JPanel.new do |p|
          p.layout = BoxLayout.new(:Y_AXIS)
          JLabel.new("Notepad")
          JTextArea.new
        end

        # tab #3
        jl = JLabel.new("This is a JTabbedPane Example.")

        # tab settings
        tp.set_titles(['First tab', 'Second Tab'])
        tp.set_icons(['', '', 'nyanco_viewer/nekobean_s.png'])
        tp.set_tips((1..3).to_a.map { |num| "tip#{num}" })
      end

      f.visible = true
    end
  end
end

JTabbedPaneExample.new
