module SNT
  module Report
    module API
      autoload :Base, 'snt/report/api/base'
      autoload :Forecast, 'snt/report/api/forecast'
      autoload :ForecastGuestAndGroups, 'snt/report/api/forecast_guest_and_groups'
      autoload :BusinessOnTheBooks, 'snt/report/api/business_on_the_books'
      autoload :Synchronize, 'snt/report/api/synchronize'
    end
  end
end
