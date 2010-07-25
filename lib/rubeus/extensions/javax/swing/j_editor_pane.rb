JavaUtilities.extend_proxy("javax.swing.JEditorPane") do
  def self.default_event_type
    return :hyperlink
  end
end
