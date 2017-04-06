module SNT
  module Report
    module API
      class Forecast < Base
        class << self
          def get(*filters)
            api.call('get', filters, namespace: 'reports/forecast', timeout: 60)
          end
        end
      end
    end
  end
end
