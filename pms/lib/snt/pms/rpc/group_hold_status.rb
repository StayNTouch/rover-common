module SNT
  module PMS
    module RPC
      class GroupHoldStatus < Base
        class << self
          # Query should contain hotel_id
          # ::SNT::PMS::RPC::GroupHoldStatus.list(1)
          def list(hotel_id)
            api.call('list', hotel_id, namespace: :group_hold_status)
          end
        end
      end
    end
  end
end
