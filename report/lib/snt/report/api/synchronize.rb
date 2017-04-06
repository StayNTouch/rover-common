module SNT
  module Report
    module API
      class Synchronize < Base
        class << self
          # ::SNT::Report::API::Synchronize.hotel(1)
          def hotel(id, options = {})
            params = [ id ]

            if options.key?(:from_date) || options.key?(:to_date)
              params += [ options[:from_date], options[:to_date] ]
            end

            api.call('synchronize', params , namespace: 'facts/financial_transaction', timeout: 600)
            api.call('synchronize', params, namespace: 'facts/group', timeout: 600)
            api.call('synchronize', params, namespace: 'facts/reservation_instance', timeout: 600)
          end
        end
      end
    end
  end
end
