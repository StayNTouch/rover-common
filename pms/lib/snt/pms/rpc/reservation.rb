module SNT
  module PMS
    module RPC
      # Interface to PMS Reservation API
      class Reservation < Base
        class << self
          # ::SNT::PMS::RPC::Reservation.find(1)
          def find(id)
            api.call('find', id, namespace: :reservation, timeout: 30)
          end

          # Query should contain hotel_id
          # ::SNT::PMS::RPC::Reservation.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ] , namespace: :reservation, timeout: 6000)
          end
        end
      end
    end
  end
end
