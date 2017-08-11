require 'snt/core'

module SNT
  module Webhook
    require 'snt/webhook/core_ext'
    require 'snt/webhook/errors'

    autoload :API, 'snt/webhook/api'
    autoload :RPC, 'snt/webhook/rpc'
  end
end
