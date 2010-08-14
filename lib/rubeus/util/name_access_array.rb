require 'rubeus/util'

module Rubeus::Util
  class NameAccessArray < Array
    def initialize(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options = {
        :name_attr => :name,
        :detect_with => :to_s
      }.update(options)
      @name_attr = options[:name_attr]
      @detect_with = options[:detect_with]
      args.each{|arg| push(arg)}
    end

    def by_name(name)
      return nil unless name
      detect_name = name.send(@detect_with)
      detect do |item|
        next unless item
        ite_name = item.send(@name_attr)
        next unless ite_name
        ite_name.send(@detect_with) == detect_name
      end
    end

    def [](*args)
      if args.length == 1
        if (args.first.is_a?(Symbol) || args.first.is_a?(String))
          return by_name(args.first)
        end
      end
      return super
    end
  end
end
