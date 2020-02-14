module SNT
  module Auth
    module API
      class ClientCredentials < Base
        class << self
          # Used to generate OAuth credentials based on Application Name and Chain
          # ::SNT::Auth::API::ClientCredentials.generate(params)
          def generate(params)
            api.call('generate', [params[:chain_uuid], params[:app_name]], namespace: :client_credentials, timeout: 60)
          end
        end
      end
    end
  end
end
