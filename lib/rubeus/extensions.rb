require 'rubeus/verboseable'
module Rubeus
  module Extensions
    autoload :Java, 'rubeus/extensions/java'
    autoload :Javax, 'rubeus/extensions/javax'

    class << self
      def verbose; ::Rubeus.verbose; end
      
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
          log_if_verbose("require(#{extension_path})") do
            require(extension_path)
          end
        rescue LoadError => e
          # puts "warning: #{e}"
          return nil
        end
        begin
          klass_name = class_name_for(parts)
          log_if_verbose("instance_eval(#{klass_name})") do
            instance_eval(klass_name)
          end
        rescue NameError => e
          # puts "warning: #{e}"
          return nil
        end
      end
    end
    extend ::Rubeus::Verboseable
  end
end
