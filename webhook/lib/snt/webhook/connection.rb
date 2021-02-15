require 'faraday'
require 'faraday_middleware'

module SNT
  module Webhook
    class Connection
      attr_reader :chain_uuid

      def initialize(options = {})
        @chain_uuid   = options.fetch(:chain_uuid)
        @api_endpoint = options.fetch(:api_endpoint, SNT::Webhook.config.api_endpoint)
        @open_timeout = options.fetch(:open_timeout, SNT::Webhook.config.open_timeout)
        @read_timeout = options.fetch(:read_timeout, SNT::Webhook.config.read_timeout)

        raise SNT::Webhook::Error, 'Missing API endpoint' if @api_endpoint.to_s.empty?
      end

      def request(method, url, params: nil, body: nil, headers: nil)
        body = body.to_h unless body.nil?

        response = connection.run_request(method, url, body, headers) do |request|
          request.params.update(params) unless params.nil?
        end

        response.to_hash[:body]
      end

      private

      def connection
        @connection ||= Faraday.new(
          @api_endpoint,
          headers: { 'Chain-UUID' => @chain_uuid },
          request: { open_timeout: @open_timeout, timeout: @read_timeout }
        ) do |conn|
          conn.request  :json
          conn.response :json, content_type: 'application/json'
          conn.use FaradayMiddleware::FollowRedirects, limit: 1
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
