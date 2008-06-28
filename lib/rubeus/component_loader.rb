module Rubeus
  class ComponentLoader < Module
    attr_reader :java_package, :ruby_module_path, :base_path

    def self.find_base_path(path)
      path = File.expand_path(path)
      $LOAD_PATH.detect{|load_path| path.include?(File.expand_path(load_path))}
    end
    
    def initialize(java_package, ruby_module_path, base_path = nil, &block)
      @java_package, @ruby_module_path, @base_path =
        java_package, ruby_module_path, base_path
      @base_path ||= ComponentLoader.find_base_path(ruby_module_path)
      @ruby_module_holder_name = File.basename(ruby_module_path).camelize
      super(&block)
    end
    
    def ruby_module_holder
       @ruby_module_holder ||= (self.const_get(@ruby_module_holder_name) rescue nil)
      unless @ruby_module_holder
        self.const_set(@ruby_module_holder_name, Module.new)
        @ruby_module_holder =  self.const_get(@ruby_module_holder_name)
      end
      @ruby_module_holder
    end
    
    def extended(object)
      mod = Module.new do
        def const_missing(java_class_name)
          @loader.const_get(java_class_name)
        end
      end
      object.instance_variable_set("@loader", self)
      object.extend(mod)
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
    
    def const_missing(java_class_name)
      if autoload?(java_class_name)
        feature = autolodings.delete(java_class_name.to_s) 
        require(feature)
        return const_get(java_class_name)
      end
      if java_class_name.to_s == @ruby_module_holder_name.to_s
        raise NameError, java_class_name
      end
      if java_class_name.to_s.include?('::')
        names = java_class_name.to_s.split('::', 2)
        package = names.first
        mod = ComponentLoader.new(
          [@java_package, package.underscore].join('.'),
          File.join(@ruby_module_path, package.underscore),
          @base_path)
        self.const_set(package.camelize, mod)
        mod.const_get(names.last)
      else
        begin
          require(File.join(@ruby_module_path, java_class_name.to_s.underscore))
        rescue LoadError => e
          # puts "warning: #{e}"
        end
        java_fqn = to_java_fqn(java_class_name)
        extension = nil
        begin
          extension = self.ruby_module_holder.const_get(java_class_name)
        rescue
          # puts "warning: #{$!.inspect}"
        end
        if extension
          JavaUtilities.extend_proxy(java_fqn) do
            include extension 
          end
        end
        result = instance_eval(java_fqn)
        self.const_set(java_class_name, result)
        result
      end
    rescue
      puts $!
      puts $!.backtrace.join("\n  ")
      super
    end

    def to_java_fqn(java_class_name)
      "#{java_package}.#{java_class_name}"
    end
    
    def depend_on(*java_class_names)
      java_class_names.each{|java_class_name| self.const_get(java_class_name)}
    end
  end
end
