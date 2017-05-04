require 'forwardable'
module SNT
  module Core
    module MQ
      class Configuration
        extend Forwardable
        def_delegators :@hash, :to_hash, :[], :[]=, :==, :fetch, :delete, :has_key?

        DEFAULTS = {
          # automatically_recover: true,
          heartbeat: 10,
          log: STDOUT, # Would maybe consider using snt.log?
          # network_recovery_interval: '5.0'
        }.freeze

        def initialize
          clear
        end

        def clear
          @hash = DEFAULTS.dup
        end

        def deep_merge(first, second)
          merger = proc { |_, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
          first.merge(second, &merger)
        end

        def merge(hash)
          instance = self.class.new
          instance.merge! to_hash
          instance.merge! hash
          instance
        end

        def merge!(hash)
          hash = hash.dup

          @hash = deep_merge(@hash, hash)
        end
      end
    end
  end
end
