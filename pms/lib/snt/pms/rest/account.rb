module SNT
  module PMS
    module REST
      class Account < Base
        attr_accessor :account_number,
                      :address,
                      :ar_number,
                      :email,
                      :hotel,
                      :id,
                      :name,
                      :primary_contact,
                      :tax_number,
                      :type

        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get('ext/accounts', query)

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
