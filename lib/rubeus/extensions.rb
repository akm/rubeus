require 'rubeus/verboseable'
module Rubeus
  module Extensions
    autoload :Java, 'rubeus/extensions/java'
    autoload :Javax, 'rubeus/extensions/javax'

    RUBEUS_EXTRA_PACKAGE = "jp.rubybizcommons.rubeus.extensions".freeze
    RUBEUS_EXTRA_PACKAGE_PARTS = RUBEUS_EXTRA_PACKAGE.split('.').freeze

    class << self
      def verbose; ::Rubeus.verbose; end

      private
      def package_parts(java_fqn_or_parts)
        parts = java_fqn_or_parts.is_a?(Array) ? java_fqn_or_parts : java_fqn_or_parts.split('.')
        if parts[0, RUBEUS_EXTRA_PACKAGE_PARTS.length] == RUBEUS_EXTRA_PACKAGE_PARTS
          parts = parts[RUBEUS_EXTRA_PACKAGE_PARTS.length..-1]
        end
        parts
      end

      public

      def path_for(java_fqn_or_parts)
        parts = package_parts(java_fqn_or_parts)
        "rubeus/extensions/%s" % parts.map{|part|part.underscore}.join('/')
      end

      def class_name_for(java_fqn_or_parts)
        parts = package_parts(java_fqn_or_parts)
        "Rubeus::Extensions::%s" % parts.map{|part|part.camelize}.join('::')
      end

      def find_for(java_fqn)
        parts = java_fqn.split('.')
        extension_path = path_for(parts)
        begin
          log_if_verbose("require(#{extension_path.inspect})") do
            require(extension_path)
          end
        rescue LoadError => e
          # puts "warning: #{e}"
          return nil
        end
        begin
          klass_name = class_name_for(parts)
          log_if_verbose("instance_eval(#{klass_name.inspect})") do
            instance_eval(klass_name)
          end
        rescue NameError => e
          # puts "warning: #{e}"
          return nil
        end
      end

      def apply_for(java_fqn)
        log_if_verbose("apply_for(#{java_fqn.inspect})") do
          extension = self.find_for(java_fqn)
          return nil unless extension
          @extension_applied ||= []
          unless @extension_applied.include?(java_fqn)
            log_if_verbose("JavaUtilities.extend_proxy(#{java_fqn})") do
              JavaUtilities.extend_proxy(java_fqn) do
                include extension
              end
            end
            @extension_applied << java_fqn
          end
        end
      end

    end
    extend ::Rubeus::Verboseable
  end
end
