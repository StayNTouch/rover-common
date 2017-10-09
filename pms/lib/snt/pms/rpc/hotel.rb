module SNT
  module PMS
    module RPC
      class Hotel < Base
        class << self
          # ::SNT::PMS::RPC::Hotel.find(1)
          def find(id)
            payload = api.call('find', id, namespace: :hotel)

            raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

            payload
          end

          # ::SNT::PMS::RPC::Hotel.find_by_code('code')
          def find_by_code(code)
            payload = api.call('find_by_code', [ code ], namespace: :hotel)

            raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

            payload
          end

          # ::SNT::PMS::RPC::Hotel.list
          def list(params = {})
            api.call('list', [ params ], namespace: :hotel)
          end
        end
      end
    end
  end
end
