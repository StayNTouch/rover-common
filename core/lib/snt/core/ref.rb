module SNT
  module Core
    module Ref
      SOURCE_MESSAGE_MAPPING = {}.freeze

      autoload :ReservationStatus, 'snt/core/ref/reservation_status'
      autoload :ChargeCodeType, 'snt/core/ref/charge_code_type'

      class << self
        def included(klass)
          klass.send(:extend, ClassMethods)
          klass.send(:include, InstanceMethods)
        end
      end

      module ClassMethods
        def [](id_or_value)
          value, id = self::ENUM.each_pair.select { |k,v| v == id_or_value || k == id_or_value.to_s.to_sym}.flatten

          return nil if id.nil?

          new(id: id, value: value)
        end
      end

      module InstanceMethods
        attr_accessor :id, :value

        def initialize(params)
          params.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end
  end
end
