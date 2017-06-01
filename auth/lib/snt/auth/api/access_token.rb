module SNT
  module Report
    module API
      class AccessToken < Base
        class << self
          def get(*filters)
            api.call('call', filters, namespace: 'ValidateTokenService', timeout: 60)
          end
        end
      end
    end
  end
end
