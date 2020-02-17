require 'snt/core'

module SNT
  module Webhook
    require 'snt/webhook/configuration'
    require 'snt/webhook/errors'

    autoload :API,  'snt/webhook/api'
    autoload :HTTP, 'snt/webhook/http'
  end
end
