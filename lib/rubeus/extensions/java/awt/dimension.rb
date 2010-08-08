module Rubeus::Extensions::Java::Awt
  module Dimension
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def create(*args)
        values = args
        if args.length == 0
          return new
        elsif args.length == 1
          if args.first.is_a?(Array)
            return create(*args.first)
          elsif args.first.is_a?(Rubeus::Awt::Dimension)
            return args.first
          else
            values = args.first.to_s.split("x", 2)
          end
        end
        if values.length == 2
          new(*values.map{|s|s.to_i})
        else
          raise ArgumentError, "Unsupported arguments: #{args.inspect}"
        end
      end
    end
  end
end
