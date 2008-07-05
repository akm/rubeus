module Rubeus
  class ComponentLoader < Module

    def self.class_names(*package_names)
      patterns = Regexp.union(
        *package_names.map{|package_name|
          Regexp.new(package_name.gsub(/\./, "/"))})
      classlist = File.join(ENV_JAVA["java.home"], "lib", "classlist")
      classes = []
      open(classlist) do |f|
        f.each do |line|
          classes << line.gsub(/\//, '.').strip if patterns =~ line
        end
      end
      classes
    end
    
    attr_reader :java_package
    attr_reader :class_to_package

    def initialize(java_package, &block)
      @java_package = java_package
      build_class_to_package_table
      super(&block)
    end
    
    def build_class_to_package_table
      class_names = ::Rubeus::ComponentLoader.class_names(@java_package)
      @class_to_package = {}
      class_names.each do |fqn|
        parts = fqn.split('.')
        class_name = parts.pop
        # インナークラスの拡張はその持ち主のクラスの責任とします。
        # JVM上でも同じタイミングでロードされるし。
        next if class_name.include?('$')
        package = parts.join('.')
        @class_to_package[class_name] = @class_to_package.key?(class_name) ?
          [@class_to_package[class_name], package] : package
      end
    end
    
    def included(mod)
      mod.extend(self)
    end
   
    def extended(object)
      class_name_for_method = self.name.underscore.gsub('/', '_')
      const_missing_with = "const_missing_with_#{class_name_for_method}"
      const_missing_without = "const_missing_without_#{class_name_for_method}"
      return if object.singleton_methods.include?(const_missing_with)
      loader_name = "@loader_#{class_name_for_method}".to_sym
      mod = Module.new 
      mod.send(:define_method, const_missing_with) do |const_name|
        begin
          instance_variable_get(loader_name).const_get(const_name)
        rescue
          send(const_missing_without, const_name)
        end
      end
      object.extend(mod)
      object.instance_variable_set(loader_name, self)
      object.instance_eval <<-EOS
        alias :#{const_missing_without} :const_missing
        alias :const_missing :#{const_missing_with}
      EOS
    end

    def extend_with(mod = Object)
      mod.send(:extend, self)
    end
    
    def const_missing(java_class_name)
      if autoload?(java_class_name)
        feature = autolodings.delete(java_class_name.to_s)
        require(feature)
        return const_get(java_class_name)
      end
      package = @class_to_package[java_class_name.to_s]
      raise NameError, java_class_name unless package
      if package.is_a?(Array)
        raise NameError, "cannot specified package name for #{java_class_name}: #{package.join(', ')}"
      end
      java_fqn = package.empty? ? java_class_name.to_s : "#{package}.#{java_class_name.to_s}"
      extension = extension_for(java_fqn)
      if extension
        JavaUtilities.extend_proxy(java_fqn) do
          include extension
        end
      end
      result = instance_eval(java_fqn)
      self.const_set(java_class_name, result)
      result
    rescue
      puts $!
      puts $!.backtrace.join("\n  ")
      super
    end

    def autolodings
      @autolodings ||= {}
    end
    
    def autoload(const_name, feature = nil)
      autolodings[const_name.to_s] = feature ||"#{self.name}::#{java_class_name.to_s}".underscore
    end
    
    def autoload?(const_name)
      autolodings[const_name.to_s]
    end
    
    def depend_on(*java_class_names)
      java_class_names.each{|java_class_name| self.const_get(java_class_name)}
    end

    def extension_path_for(java_fqn_or_parts)
      parts = java_fqn_or_parts.is_a?(Array) ? java_fqn_or_parts : java_fqn_or_parts.split('.')
      "rubeus/extensions/%s" % parts.map{|part|part.underscore}.join('/')
    end

    def extension_class_name_for(java_fqn_or_parts)
      parts = java_fqn_or_parts.is_a?(Array) ? java_fqn_or_parts : java_fqn_or_parts.split('.')
      "Rubeus::Extensions::%s" % parts.map{|part|part.camelize}.join('::')
    end

    def extension_for(java_fqn)
      parts = java_fqn.split('.')
      extension_path = extension_path_for(parts)
      begin
        require(extension_path)
      rescue LoadError => e
        # puts "warning: #{e}"
        return nil
      end
      begin
        instance_eval(extension_class_name_for(parts))
      rescue NameError => e
        # puts "warning: #{e}"
        return nil
      end
    end
  end
end
