module SNT
  module Auth
    module API
      autoload :Base, 'snt/auth/api/base'
      autoload :AccessToken, 'snt/auth/api/access_token'
      autoload :ClientCredentials, 'snt/auth/api/client_credentials'
    end
  end
end
