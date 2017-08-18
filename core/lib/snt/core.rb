module SNT
  module Core
    autoload :Chunker, 'snt/core/chunker'
    autoload :MQ, 'snt/core/mq'
    autoload :Ref, 'snt/core/ref'
    autoload :RPC, 'snt/core/rpc'
    autoload :Services, 'snt/core/services'
  end
end

require 'snt/core/version'
