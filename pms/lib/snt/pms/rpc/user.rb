module SNT
  module PMS
    module RPC
      class User < Base
        class << self
          # Used to authenticate the username and password of a user with an api_user role
          # ::SNT::PMS::RPC::User.authenticate_api_user(username: 'api_user@stayntouch.com', password: 'admin123')
          def authenticate_api_user(params)
            api.call('authenticate_api_user', [ params ], namespace: :user, timeout: 30)
          end
        end
      end
    end
  end
end
