module SNT
  module Auth
    module API
      class AccessToken < Base
        class << self
          def validate(token)
            api.call('call', token, namespace: 'ValidateService', timeout: 60)
          end
        end
      end
    end
  end
end
