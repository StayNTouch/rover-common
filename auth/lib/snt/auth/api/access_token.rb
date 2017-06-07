module SNT
  module Auth
    module API
      class AccessToken < Base
        class << self
          def validate(token)
            api.call('validate', token, namespace: 'AccessToken', timeout: 60)
          end
        end
      end
    end
  end
end
