require 'snt/webhook/connection'
require 'snt/webhook/rest/webhooks'

module SNT
  module Webhook
    class Client
      def initialize(chain_uuid:, **options)
        @options = options.merge(chain_uuid: chain_uuid)
      end

      def webhooks
        @webhooks ||= SNT::Webhook::REST::Webhooks.new(SNT::Webhook::Connection.new(@options))
      end
    end
  end
end
