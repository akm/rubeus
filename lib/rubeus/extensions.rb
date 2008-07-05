module Rubeus
  module Extensions
    autoload :Java, 'rubeus/extensions/java'
    autoload :Javax, 'rubeus/extensions/javax'

    class << self
      def path_for(java_fqn_or_parts)
        parts = java_fqn_or_parts.is_a?(Array) ? java_fqn_or_parts : java_fqn_or_parts.split('.')
        "rubeus/extensions/%s" % parts.map{|part|part.underscore}.join('/')
      end

      def class_name_for(java_fqn_or_parts)
        parts = java_fqn_or_parts.is_a?(Array) ? java_fqn_or_parts : java_fqn_or_parts.split('.')
        "Rubeus::Extensions::%s" % parts.map{|part|part.camelize}.join('::')
      end

      def find_for(java_fqn)
        parts = java_fqn.split('.')
        extension_path = path_for(parts)
        begin
          require(extension_path)
        rescue LoadError => e
          # puts "warning: #{e}"
          return nil
        end
        begin
          instance_eval(class_name_for(parts))
        rescue NameError => e
          # puts "warning: #{e}"
          return nil
        end
      end
    end
  end
end
