module SNT
  module PMS
    module RPC
      class ExternalMapping < Base
        attr_accessor :external_value,
                      :type,
                      :value

        class << self
          def all
            where
          end

          # ::SNT::PMS::RPC::ExternalMapping.where(interface: 'accountview', hotel_code: 'GHLD')
          def where(query = {})
            payload = api.call('interface', [ query ], namespace: :mapping)

            raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

            payload['results'].inject([]) do |objects, obj|
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
