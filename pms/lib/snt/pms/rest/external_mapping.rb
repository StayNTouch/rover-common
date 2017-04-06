module SNT
  module PMS
    module REST
      class ExternalMapping < Base
        attr_accessor :external_value,
                      :type,
                      :value

        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get("ext/hotels/settings/external_mappings/#{query.delete(:interface)}", query)

            raise payload[:error] if payload[:error]

            payload[:body]['results'].inject([]) do |objects, obj|
              # Select the attributes from the attributes key
              object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

              objects << new(object_attributes)
            end
          end
        end
      end
    end
  end
end
