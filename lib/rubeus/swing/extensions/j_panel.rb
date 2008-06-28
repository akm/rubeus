module Rubeus::Swing::Extensions
  module JPanel
  end
end

JavaUtilities.extend_proxy('javax.swing.JPanel') do
  perform_as_container
end
