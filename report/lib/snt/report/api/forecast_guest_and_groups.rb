module SNT
  module Report
    module API
      class ForecastGuestAndGroups < Base
        class << self
          def get(*filters)
            api.call('get', filters, namespace: 'reports/forecast_guest_and_groups')
          end
        end
      end
    end
  end
end
