module SNT
  module PMS
    module REST
      class DailyBalance < Base
        attr_accessor :ar,
                      :deposit,
                      :guest

        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get("ext/daily_balances/#{query.delete(:date)}", query)

            raise payload[:error] if payload[:error]

            new(payload[:body]['results'])
          end
        end

        def ledgers
          {
            ar: @ar,
            deposit: @deposit,
            guest: @guest
          }
        end
      end
    end
  end
end
