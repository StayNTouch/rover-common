module SNT
  module PMS
    module REST
      class Payment < Base
        attr_accessor :account,
                      :amount,
                      :charge_code,
                      :date,
                      :description,
                      :hotel,
                      :id,
                      :parent_transaction_id
        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get('ext/financial_transactions/payments', query)

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
