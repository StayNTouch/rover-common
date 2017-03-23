module SNT
  module Core
    module Ref
      class ChargeCodeType
        include ::SNT::Core::Ref

        ENUM = { TAX: 1, PAYMENT: 2, ADDON: 3, OTHERS: 4, ROOM: 5, FEES: 6 }.freeze
      end
    end
  end
end
