module SNT
  module PMS
    module RPC
      class PostingAccount < Base
        class << self
          # Query should contain hotel_id
          # ::SNT::PMS::RPC::PostingAccount.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ], namespace: :posting_account, timeout: 300)
          end
        end
      end
    end
  end
end
