module SNT
  module Core
    autoload :Chunker, 'snt/core/chunker'
    autoload :MQ, 'snt/core/mq'
    autoload :Ref, 'snt/core/ref'
    autoload :RPC, 'snt/core/rpc'
    autoload :Services, 'snt/core/services'
    autoload :OpenTracing, 'snt/core/open_tracing'
  end
end

require 'snt/core/version'
