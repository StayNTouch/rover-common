module SNT
  module Webhook
    module REST
      class Base
        # rubocop:disable Style/TrivialAccessors
        def self.resource(resource)
          @resource = resource
        end
        # rubocop:enable  Style/TrivialAccessors

        def self.resource_name
          @resource.to_s
        end

        def initialize(connection)
          @connection = connection
        end

        def get(url, params = {})
          # Must provide the chain uuid as a query parameter until the Webhook
          # service has been updated to retrieve it from the request headers.
          @connection.request(:get, url, params: params.merge(chain_uuid: @connection.chain_uuid))
        end

        def post(url, data)
          @connection.request(:post, url, body: data)
        end

        def put(url, data)
          @connection.request(:put, url, body: data)
        end

        def delete(url)
          @connection.request(:delete, url)
        end

        def path(component = nil)
          resource_path.join(component.to_s).to_path
        end

        def resource_name
          self.class.resource_name
        end

        private

        def resource_path
          @resource_path ||= Pathname.new(resource_name)
        end
      end
    end
  end
end
