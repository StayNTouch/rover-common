require 'sneakers'
require 'sneakers_packer'
module SNT
  module Report
    class RPC
      # Sanitize options being sent to
      # SneakerPacker remote_call method.
      def self.compile_options(options)
        defaults = {
          timeout: nil
        }

        defaults.merge((options.is_a?(Hash) ? options : {}).delete_if { |k, _| !defaults.key?(k) }).compact
      end

      def self.call(method, message, options = {})
        SneakersPacker.remote_call(
          'report.api.rpc',
          { report: method,
            params: message },
          compile_options(options)
        )
      end
    end
  end
end
