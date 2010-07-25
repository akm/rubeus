JavaUtilities.extend_proxy("javax.swing.JList") do
  def self.default_event_type
    return :list_selection
  end
end
