module FastJsonapi
  class Scalar
    attr_reader :key, :method, :conditional_proc, :comment

    def initialize(key:, method:, options: {})
      @key = key
      @method = method
      @conditional_proc = if options[:if].present?
        options[:if]
      else
        nil
      end
      @comment= options[:comment]
    end

    def serialize(record, serialization_params, output_hash)
      if @conditional_proc.nil? || @conditional_proc.call(record, serialization_params)
        output_hash[@key] = if @method.is_a?(Proc)
          @method.arity.abs == 1 ? @method.call(record) : @method.call(record, serialization_params)
        else
          record.public_send(@method)
        end
      end
    end

    def conditionally_allowed?(record, serialization_params)
      if @conditional_proc
        @conditional_proc.call(record, serialization_params)
      else
        true
      end
    end
  end
end
