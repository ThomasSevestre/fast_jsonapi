module FastJsonapi
  class Attribute
    def initialize(key:, method:, options: {})
      @key = key
      @method = method
      @conditional_proc = if options[:if].present?
        options[:if]
      else
        nil
      end
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
  end
end
