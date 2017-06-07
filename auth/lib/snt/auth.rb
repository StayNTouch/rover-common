require 'snt/core'

module SNT
  module Auth
    require 'snt/auth/core_ext'
    require 'snt/auth/errors'

    autoload :API, 'snt/auth/api'
    autoload :RPC, 'snt/auth/rpc'
  end
end
