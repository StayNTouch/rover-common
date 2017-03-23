module SNT
  module Core
    module Ref
      class ReservationStatus
        include ::SNT::Core::Ref

        ENUM = { RESERVED: 1, CHECKEDIN: 2, CHECKEDOUT: 3, NOSHOW: 4, CANCELED: 5, PRE_CHECKIN: 6 }.freeze
      end
    end
  end
end
