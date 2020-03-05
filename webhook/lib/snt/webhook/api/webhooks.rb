module SNT
  module Webhook
    module API
      module Webhooks
        module_function

        # Define basic api methods
        #
        # ::SNT::Webhook::API::Webhooks.index(chain_uuid)
        # ::SNT::Webhook::API::Webhooks.show(uuid)
        # ::SNT::Webhook::API::Webhooks.create(params)
        # ::SNT::Webhook::API::Webhooks.update(uuid, params)
        # ::SNT::Webhook::API::Webhooks.destroy(uuid)
        def index(chain_uuid)
          client = SNT::Webhook::Client.new(chain_uuid: chain_uuid)
          client.webhooks.list
        end

        def show(uuid)
          client = SNT::Webhook::Client.new
          client.webhooks.retrieve(uuid)
        end

        def create(params)
          client = SNT::Webhook::Client.new
          client.webhooks.create(params)
        end

        def update(uuid, params)
          client = SNT::Webhook::Client.new
          client.webhooks.update(uuid, params)
        end

        def destroy(uuid)
          client = SNT::Webhook::Client.new
          client.webhooks.destroy(uuid)
        end

        # ::SNT::Webhook::API::Webhooks.supporting_events
        def supporting_events
          client = SNT::Webhook::Client.new(read_timeout: 60)
          client.webhooks.supporting_events
        end

        # ::SNT::Webhook::API::Webhooks.delivery_types
        def delivery_types
          client = SNT::Webhook::Client.new(read_timeout: 60)
          client.webhooks.delivery_types
        end
      end
    end
  end
end
