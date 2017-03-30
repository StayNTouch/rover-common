require 'snt/core'

module SNT
  module Report
    require 'snt/report/core_ext'
    require 'snt/report/errors'

    autoload :API, 'snt/report/api'
    autoload :RPC, 'snt/report/rpc'
  end
end
