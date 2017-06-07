module SNT
  module PMS
    module RPC
      autoload :Base, 'snt/pms/rpc/base'
      autoload :ChargeCode, 'snt/pms/rpc/charge_code'
      autoload :ExternalMapping, 'snt/pms/rpc/external_mapping'
      autoload :FinancialTransaction, 'snt/pms/rpc/financial_transaction'
      autoload :Group, 'snt/pms/rpc/group'
      autoload :GroupHoldStatus, 'snt/pms/rpc/group_hold_status'
      autoload :Hotel, 'snt/pms/rpc/hotel'
      autoload :Reservation, 'snt/pms/rpc/reservation'
      autoload :ReservationDailyInstance, 'snt/pms/rpc/reservation_daily_instance'
      autoload :User, 'snt/pms/rpc/user'
    end
  end
end
