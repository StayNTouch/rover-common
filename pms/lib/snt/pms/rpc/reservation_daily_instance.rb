module SNT
  module PMS
    module RPC
      class ReservationDailyInstance < Base
        class << self
          # ::SNT::PMS::RPC::ReservationDailyInstance.find(1)
          def find(id)
            api.call('find', id, namespace: :reservation_daily_instance)
          end
        end
      end
    end
  end
end
