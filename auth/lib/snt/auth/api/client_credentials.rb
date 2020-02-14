module SNT
  module Auth
    module API
      class ClientCredentials < Base
        class << self
          # Used to validate an OAuth 2.0 access token is present and not expired
          # ::SNT::Auth::API::AccessToken.validate('Bearer 2105655529552d7ffdbe995c5d9b6e49c614c4e177db73735501773bc71ff431')
          def generate(params)
            api.call('generate', [params[:chain_uuid], params[:app_name]], namespace: :client_credentials, timeout: 60)
          end
        end
      end
    end
  end
end
