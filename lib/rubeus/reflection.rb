# -*- coding: utf-8 -*-
require "rubeus/component_loader"

module Rubeus
  Reflection = ComponentLoader.new("java.lang.reflect") do

    def self.irb
      self.extend_with
    end
  end
end

java.lang.reflect.Method # 参照して予め拡張しておきます
# java.util.AbstractList.java_class.declared_instance_methods などで得られる
# 配列中のオブジェクトは、Java::JavaLangReflectMethodではなく実はJava::JavaMethodなので、
# java.lang.reflect.Methodと同じように拡張しておく
Java::JavaMethod.send(:include, Rubeus::Extensions::Java::Lang::Reflect::Method)
