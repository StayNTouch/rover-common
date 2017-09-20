module SNT
  module Report
    module API
      class BusinessOnTheBooks < Base
        class << self
          def get(*filters)
            api.call('get', filters, namespace: 'reports/business_on_the_books', timeout: 60)
          end
        end
      end
    end
  end
end
