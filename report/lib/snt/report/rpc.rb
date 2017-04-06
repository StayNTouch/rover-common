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

      # Execute remote procedural call on the report application
      #
      # @param method [String] Name of method to call
      # @param message [Object] Argument list to send to remote method
      # @param options [Hash] Possible options include: timeout [Integer], namespace [String]
      # @return [Object] Response from remote service
      #
      def self.call(method, message, options = {})
        SneakersPacker.remote_call(
          'report.api.rpc',
          { method: method, args: message }.tap { |o| o[:namespace] = options[:namespace] if options.key?(:namespace) },
          compile_options(options)
        )
      end
    end
  end
end
