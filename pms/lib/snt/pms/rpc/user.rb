module SNT
  module PMS
    module RPC
      class User < Base
        class << self
          # ::SNT::PMS::RPC::User.authenticate_api_user(1)
          def authenticate_api_user(params)
            api.call('authenticate_api_user', [ params ], namespace: :user, timeout: 30)
          end
        end
      end
    end
  end
end
