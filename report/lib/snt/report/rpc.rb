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
      def call(method, message, options = {})
        queue = options.delete(:queue) || 'api'

        SneakersPacker.remote_call(
          "report.#{queue}.rpc",
          {
            request_id: SecureRandom.uuid,
            # Set expires_at based on SneakersPacker rpc_timeout in seconds of Epoch format per rfc1057
            expires_at: Time.now.to_f + (options[:timeout] || SneakersPacker.conf.rpc_timeout).to_f,
            created_at: Time.now.to_f,
            method: method,
            args: message
          }.tap { |o| o[:namespace] = options[:namespace] if options.key?(:namespace) },
          compile_options(options)
        )
      end
    end
  end
end
