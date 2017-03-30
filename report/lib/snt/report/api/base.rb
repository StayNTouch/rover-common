require 'net/https'
require 'uri'

module SNT
  module Report
    module API
      class Base
        attr_accessor :error

        def initialize(params = {})
          params.each do |k, v|
            instance_variable_set("@#{k.to_sym}", v) if attributes.include?(k.to_sym)
          end
        end

        def api
          @api ||= self.class.api
        end

        def attributes
          self.class.attributes
        end

        def fields
          self.class.fields
        end

        def success?
          @error.nil?
        end

        def assign_params(params)
          params.each do |k, v|
            instance_variable_set("@#{k.to_sym}", v) if attributes.include?(k.to_sym)
          end
        end

        def to_hash
          {}.tap do |hash|
            attributes.compact.each do |attribute|
              hash[attribute] = instance_variable_get("@#{attribute}")
            end
          end.compact
        end

        # Skip nil, empty array and empty hash.
        def skip_value?(value)
          value.nil? || ((value.is_a?(Array) || value.is_a?(Hash)) && value.empty?)
        end

        class << self
          attr_reader :attributes, :fields

          def attr_accessor(*vars)
            @attributes ||= []
            @attributes.concat vars

            @fields ||= []
            @fields.concat vars

            super(*vars)
          end

          def attr_reader(*vars)
            @attributes ||= []
            @attributes.concat vars
            super(*vars)
          end

          def api
            SNT::Report::RPC
          end
        end
      end
    end
  end
end
