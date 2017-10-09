module SNT
  module PMS
    module RPC
      class InactiveRoom < Base
        class << self
          # Query should contain hotel_id
          # ::SNT::PMS::RPC::InactiveRoom.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [hotel_id, params], namespace: :inactive_room, timeout: 300)
          end
        end
      end
    end
  end
end
