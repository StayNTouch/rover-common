module SNT
  module Report
    module API
      class Forecast < Base
        class << self
          def get(*filters)
            api.call('get', filters, namespace: 'reports/forecast')
          end
        end
      end
    end
  end
end
