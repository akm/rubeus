JavaUtilities.extend_proxy("javax.swing.JTextField") do
  def self.default_event_type
    return :key, :pressed
  end
end
