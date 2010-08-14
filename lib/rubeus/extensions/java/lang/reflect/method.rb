module Rubeus::Extensions::Java::Lang::Reflect
  module Method
    MODIFIER = java.lang.reflect.Modifier

    def package_scope?
      !(private? || protected? || public?)
    end

    MODIFIER_SYMBOLS = MODIFIER.constants.map{|const_name| const_name.downcase.to_sym}.freeze
    def modifier_symbols
      MODIFIER_SYMBOLS.select{|sym| send("#{sym}?")}
    end

    defined_methods = java.lang.reflect.Method.instance_methods
    MODIFIER_SYMBOLS.each do |modifier_sym|
      next if defined_methods.include?("#{modifier_sym}?")
      module_eval(<<-"EOS")
        def #{modifier_sym}?; MODIFIER.#{modifier_sym}?(modifiers); end
      EOS
    end

  end
end
