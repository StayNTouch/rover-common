module SNT
  module PMS
    module RPC
      class FutureTransaction < Base
        class << self
          # Query should contain hotel_id
          # ::SNT::PMS::RPC::FutureTransaction.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ], namespace: :future_transaction)
          end
        end
      end
    end
  end
end
