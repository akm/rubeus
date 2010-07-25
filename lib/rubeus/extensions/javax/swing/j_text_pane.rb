Rubeus::Swing.depend_on('JEditorPane')

JavaUtilities.extend_proxy("javax.swing.JTextPane") do
  def self.default_event_type
    return :key, :pressed
  end
end
