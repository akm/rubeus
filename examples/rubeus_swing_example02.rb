require 'rubygems'
require 'rubeus'
 
Rubeus::Swing.irb
 
JFrame.new do |frame|
  label = JLabel.new
 
  t = Timer.new(500) do
    label.text = Time.now.to_s
  end
  t.start
 
  frame.title = "Rubeus Timer Example"
  frame.size = "250 x 50"
  frame.visible = true
end
