module SNT
  module PMS
    module RPC
      class FinancialTransaction < Base
        class << self
          # ::SNT::PMS::RPC::FinancialTransaction.find(301)
          def find(id)
            api.call('find', id, namespace: :financial_transaction, timeout: 30)
          end

          # Query should contain hotel_id
          # ::SNT::PMS::RPC::FinancialTransaction.list(1, limit: 1)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ], namespace: :financial_transaction, timeout: 6000)
          end
        end
      end
    end
  end
end
