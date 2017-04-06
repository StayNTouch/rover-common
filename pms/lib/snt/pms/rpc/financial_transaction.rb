module SNT
  module PMS
    module RPC
      class FinancialTransaction < Base
        class << self
          # ::SNT::PMS::RPC::FinancialTransaction.find(301)
          def find(id)
            api.call('find', id, namespace: :financial_transaction, timeout: 30)
          end
        end
      end
    end
  end
end
