# -*- coding: utf-8 -*-
require 'rubeus/verboseable'
require 'java'
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

    include ::Rubeus::Verboseable

    attr_accessor :verbose
    attr_reader :java_package
    attr_reader :class_to_package

    def initialize(java_package, &block)
      self.verbose = Rubeus.verbose
      build_class_to_package_table(java_package)
      java_package = JavaUtilities.get_package_module_dot_format(java_package)
      class << java_package
        include Rubeus::JavaPackage
        include Verboseable
      end
      java_package.verbose = self.verbose
      super(&block)
    end

    def build_class_to_package_table(java_package)
      class_names = ::Rubeus::ComponentLoader.class_names(java_package)
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
      object.instance_eval(<<-"EOS")
        alias :#{const_missing_without} :const_missing
        alias :const_missing :#{const_missing_with}
      EOS
    end

    def extend_with(mod = Object)
      mod.send(:extend, self)
    end

    def const_missing(java_class_name)
      if autoload?(java_class_name)
        log_if_verbose("autoloading... #{java_class_name.to_s}")
        feature = autolodings.delete(java_class_name.to_s)
        log_if_verbose("require(#{feature})") do
          require(feature)
        end
        return const_get(java_class_name)
      end
      package = @class_to_package[java_class_name.to_s]
      raise NameError, java_class_name unless package
      if package.is_a?(Array)
        raise NameError, "cannot specified package name for #{java_class_name}: #{package.join(', ')}"
      end
      java_fqn = package.empty? ? java_class_name.to_s : "#{package}.#{java_class_name.to_s}"
      extension = Rubeus::Extensions.apply_for(java_fqn)
      result = log_if_verbose("instance_eval(#{java_fqn})") do
        instance_eval(java_fqn)
      end
      self.const_set(java_class_name, result)
      result
    rescue
      log_if_verbose($!)
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
  end

  module JavaPackage
    def self.included(object)
      raise "JavaPackage must be extended by a Module" unless object.is_a?(Module)
      object.module_eval do
        attr_accessor :verbose
        alias :method_missing_without_rubeus :method_missing
        alias :method_missing :method_missing_with_rubeus
        alias :const_missing_without_rubeus :const_missing
        alias :const_missing :const_missing_with_rubeus
      end
    end

    def method_missing_with_rubeus(method, *args)
      java_fqn = "#{@package_name}#{method.to_s}"
      extension = Rubeus::Extensions.apply_for(java_fqn)
      result = method_missing_without_rubeus(method, *args)
      class << result
        include ::Rubeus::JavaPackage
        include Verboseable
      end
      result.verbose = self.verbose
      result
    end

    def const_missing_with_rubeus(const_name)
      result = const_missing_without_rubeus(const_name)
      puts("#{self.name}.const_missing(#{const_name.inspect}) => #{result.inspect}")
      result
    end
  end
end
