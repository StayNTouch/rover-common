require 'json'
require 'net/http'
require 'uri'

module SNT
  module Webhook
    module HTTP
      module_function

      HTTP_METHODS = {
        get:    Net::HTTP::Get,
        post:   Net::HTTP::Post,
        patch:  Net::HTTP::Patch,
        put:    Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.freeze

      def get(path, params = {})
        path = "#{path}?#{URI.encode_www_form(params)}" unless params.empty?
        request(:get, path)
      end

      def post(path, data)
        request(:post, path, data)
      end

      def patch(path, data)
        request(:patch, path, data)
      end

      def put(path, data)
        request(:put, path, data)
      end

      def delete(path)
        request(:delete, path)
      end

      private

      def connect
        raise SNT::Webhook::Errors::Error, 'Missing API endpoint' if SNT::Webhook.config.api_endpoint.to_s.empty?
        uri = URI.parse(SNT::Webhook.config.api_endpoint)

        Net::HTTP.start(
          uri.host,
          uri.port,
          open_timeout: SNT::Webhook.config.open_timeout,
          read_timeout: SNT::Webhook.config.read_timeout,
          use_ssl: uri.scheme == 'https'
        ) do |http|
          response = yield http
          JSON.parse(response.body)
        end
      end

      def request(method_name, path, data = {})
        method = HTTP_METHODS[method_name].new(path)

        connect do |http|
          method.add_field('Accept', 'application/json')
          method.set_form_data(transform_keys_of_array_values(data)) unless data.empty?
          http.request(method)
        end
      end

      # Rails POST|PATCH|PUT parameters encoded as application/x-www-form-urlencoded
      # encode arrays like this:
      #
      # colors[]=red&colors[]=yellow&colors[]=blue
      #
      # The resulting params hash is in this case:
      #
      # {"colors" => ["red", "yellow", "blue"]}
      #
      # Net::HTTPHeader#set_form_data encodes elements with array values like this:
      #
      # colors=red&colors=yellow&colors=blue
      #
      # The resulting params hash loses all but the last value of the array:
      #
      # {"colors" => "blue"}
      #
      # This method finds elements with array values and appends "[]" to their
      # keys like this:
      #
      # {"colors[]" => ["red", "yellow", "blue"]}
      #
      # so that Net::HTTP POST|PUT|PATCH encodes arrays in the same format as Rails:
      #
      # colors[]=red&colors[]=yellow&colors[]=blue
      #
      # resulting in a params hash that preserves the array:
      #
      # {"colors" => ["red", "yellow", "blue"]}
      def transform_keys_of_array_values(params)
        params.each_with_object({}) do |(k, v), h|
          v.is_a?(Array) ? h["#{k}[]"] = v : h[k] = v
        end
      end
    end
  end
end
