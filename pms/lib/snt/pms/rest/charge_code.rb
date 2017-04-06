module SNT
  module PMS
    module REST
      class ChargeCode < Base
        attr_accessor :charge_code,
                      :charge_code_type,
                      :description,
                      :financial_transactions,
                      :hotel

        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get('ext/charge_codes/financial_transactions', query)

            raise payload[:error] if payload[:error]

            hotel = Hotel.new(payload[:body]['results']['hotel'])

            payload[:body]['results']['charge_codes'].inject([]) do |objects, obj|
              # Select the attributes from the attributes key
              object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

              # Add hotel to attributes
              object_attributes[:hotel] = hotel

              objects << new(object_attributes)
            end
          end
        end
      end
    end
  end
end
