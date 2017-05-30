module SNT
  module Report
    module API
      autoload :Base, 'snt/report/api/base'
      autoload :Forecast, 'snt/report/api/forecast'
      autoload :Synchronize, 'snt/report/api/synchronize'
      autoload :ForecastGuestAndGroups, 'snt/report/api/forecast_guest_and_groups'
    end
  end
end
