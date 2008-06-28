Rubeus::Swing.depend_on('JPanel')

JavaUtilities.extend_proxy('javax.swing.JFrame') do
  perform_as_container
end
