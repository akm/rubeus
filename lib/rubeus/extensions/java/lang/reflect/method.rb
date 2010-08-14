Rubeus::Reflection.depend_on("AccessibleObject")

module Rubeus::Extensions::Java::Lang::Reflect
  module Method
    MODIFIER = java.lang.reflect.Modifier
    MODIFIER.constants.each do |const_name|
      method_base = const_name.downcase
      module_eval(<<-"EOS")
        def #{method_base}?; MODIFIER.#{method_base}?(getModifiers); end
      EOS
    end
  end
end
