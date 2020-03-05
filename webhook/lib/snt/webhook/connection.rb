require 'faraday'
require 'faraday_middleware'

module SNT
  module Webhook
    class Connection
      attr_reader :chain_uuid

      def initialize(options = {})
        raise SNT::Webhook::Error, 'Missing API endpoint' if SNT::Webhook.config.api_endpoint.to_s.empty?
        @chain_uuid   = options.fetch(:chain_uuid, nil)
        @open_timeout = options.fetch(:open_timeout, SNT::Webhook.config.open_timeout)
        @read_timeout = options.fetch(:read_timeout, SNT::Webhook.config.read_timeout)
      end

      def request(method, url, params: nil, body: nil, headers: nil)
        response = connection.run_request(method, url, body, headers) do |request|
          request.params.update(params) unless params.nil?
        end

        response.to_hash[:body]
      end

      private

      def connection
        @connection ||= Faraday.new(SNT::Webhook.config.api_endpoint, {
          request: {open_timeout: @open_timeout, timeout: @read_timeout}
        }) do |conn|
          conn.headers['Chain-UUID'] = @chain_uuid unless @chain_uuid.nil?
          conn.request  :json
          conn.response :json, content_type: 'application/json'
          conn.use FaradayMiddleware::FollowRedirects, limit: 1
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end

