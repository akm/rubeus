JavaUtilities.extend_proxy('javax.swing.JPanel') do
  perform_as_container
end

Rubeus::Swing.attach_component('JPanel')
