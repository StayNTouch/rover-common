module SNT
  module PMS
    module RPC
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

          # charge_codes = ::SNT::PMS::RPC::ChargeCode.where(hotel_code: @property.code, date: date)
          def where(query = {})
            payload = api.call('charge_code_journals', [ query ], namespace: :accounting)

            raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

            hotel = Hotel.new(payload['results']['hotel'])

            payload['results']['charge_codes'].inject([]) do |objects, obj|
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
