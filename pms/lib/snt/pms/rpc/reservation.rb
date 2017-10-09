module SNT
  module PMS
    module RPC
      # Interface to PMS Reservation API
      class Reservation < Base
        class << self
          # ::SNT::PMS::RPC::Reservation.find(1)
          def find(id)
            api.call('find', id, namespace: :reservation)
          end

          # Query should contain hotel_id
          # ::SNT::PMS::RPC::Reservation.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ], namespace: :reservation)
          end
        end
      end
    end
  end
end
