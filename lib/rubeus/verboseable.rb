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
      msg = "#{name} %s" %
        messages.map{|m| m.is_a?(Exception) ? ("#{m.to_s}\n%s" % m.backtrace.join("\n  ")) : m }.
        join("\n")
      @@indent ||= 0
      if @@indent > 0
        msg.gsub!(/^/, '  ' * @@indent)
      end
      if block_given?
        indent_backup = @@indent
        @@indent += 1
        Verboseable.out.puts("#{msg} {")
        begin
          return yield
        rescue Exception => err
          Verboseable.out.puts("#{'  ' * @@indent} RAISED: #{err.inspect}")
          raise
        ensure
          @@indent = indent_backup
          Verboseable.out.puts("#{'  ' * @@indent}}")
        end
      else
        Verboseable.out.puts(msg)
      end
    end
  end
end
