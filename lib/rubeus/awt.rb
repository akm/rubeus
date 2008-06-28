require "rubeus/component_loader"

module Rubeus
  extensions_path = File.join(File.dirname(__FILE__), "awt", "extensions")
  Awt = ComponentLoader.new("java.awt", extensions_path) do
    base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    Dir.glob(File.join(base_path, 'rubeus', 'awt', '*.rb')) do |file|
      rel_path = file.gsub("#{base_path}/", '')
      autoload(File.basename(rel_path, '.*').camelize, rel_path.gsub(/\.rb$/, ''))
    end
  end
end

require "rubeus/awt/extensions"
