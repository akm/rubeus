module Rubeus
  module Verboseable
    class << self
      def out
        @out || $stderr
      end
      
      def out=(value)
        @out = value
      end
    end
    
    def log_if_verbose(*messages)
      return(block_given? ? yield : nil) unless self.verbose
      name = is_a?(Module) ? self.name : self.class.name
      msg = "#{name} #{messages.join("\n")}"
      if block_given?
        Verboseable.out.puts("#{msg} BEGIN")
        begin
          result = yield
          Verboseable.out.puts("#{msg} END")
          result
        rescue Exception => err
          Verboseable.out.puts("#{msg} RAISED: #{err.inspect}")
          raise
        end
      else
        Verboseable.out.puts(msg)
      end
    end
  end
end
