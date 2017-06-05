module SNT
  module Auth
    module API
      class AccessToken < Base
        class << self
          def validate(token)
            api.call('call', token, namespace: 'AccessToken::Validate', timeout: 60)
          end
        end
      end
    end
  end
end
