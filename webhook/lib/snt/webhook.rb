require 'snt/core'
require 'snt/webhook/configuration'
require 'snt/webhook/errors'

module SNT
  module Webhook
    autoload :Client, 'snt/webhook/client'
    autoload :API,    'snt/webhook/api'
  end
end
