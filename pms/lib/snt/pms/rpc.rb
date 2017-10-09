module SNT
  module PMS
    module RPC
      autoload :Base, 'snt/pms/rpc/base'
      autoload :ChargeCode, 'snt/pms/rpc/charge_code'
      autoload :ExternalMapping, 'snt/pms/rpc/external_mapping'
      autoload :FinancialTransaction, 'snt/pms/rpc/financial_transaction'
      autoload :FutureTransaction, 'snt/pms/rpc/future_transaction'
      autoload :Group, 'snt/pms/rpc/group'
      autoload :GroupHoldStatus, 'snt/pms/rpc/group_hold_status'
      autoload :Hotel, 'snt/pms/rpc/hotel'
      autoload :PostingAccount, 'snt/pms/rpc/posting_account'
      autoload :Reservation, 'snt/pms/rpc/reservation'
      autoload :ReservationDailyInstance, 'snt/pms/rpc/reservation_daily_instance'
      autoload :User, 'snt/pms/rpc/user'
      autoload :InactiveRoom, 'snt/pms/rpc/inactive_room'
    end
  end
end
