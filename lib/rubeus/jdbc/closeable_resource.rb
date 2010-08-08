module Rubeus::Jdbc
  module CloseableResource
    def with_close(resource)
      if block_given?
        begin
          yield(resource)
        ensure
          resource.close
        end
        return nil
      else
        resource
      end
    end
  end
end
