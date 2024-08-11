# frozen_string_literal: true

module SchemaDoctor
  class Utils
    class << self
      def sefety_dump_hash(obj)
        case obj
        when Hash
          obj.transform_values { |v| sefety_dump_hash(v) }
        when Array
          obj.map { |v| sefety_dump_hash(v) }
        when TrueClass, FalseClass, NilClass, Integer, Float, String
          obj
        else
          obj.to_s
        end
      end

      def deep_stringify(obj)
        case obj
        when Hash
          obj.transform_keys(&:to_s).transform_values { |v| deep_stringify(v) }
        when Array
          obj.map { |v| deep_stringify(v) }
        else
          obj
        end
      end
    end
  end
end
