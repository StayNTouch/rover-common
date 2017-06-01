module SNT
  module Report
    module API
      class AccessToken < Base
        class << self
          def validate(token)
            api.call('call', token, namespace: 'ValidateTokenService', timeout: 60)
          end
        end
      end
    end
  end
end
