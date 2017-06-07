module SNT
  module PMS
    module RPC
      class User < Base
        class << self
          # Used to authenticate the username and password of a user with an api_user role
          # ::SNT::PMS::RPC::User.authenticate_api_user('api_user@stayntouch.com', 'admin123')
          def authenticate_api_user(username, password)
            api.call('authenticate_api_user', [ username, password ], namespace: :user, timeout: 30)
          end
        end
      end
    end
  end
end
