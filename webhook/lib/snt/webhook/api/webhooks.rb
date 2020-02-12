module SNT
  module Webhook
    module API
      class Webhooks < Base
        RESOURCE_PATH = Pathname.new('/webhook')

        class << self
          # Define basic api methods
          #
          # ::SNT::Webhook::API::Webhooks.index(chain_uuid)
          # ::SNT::Webhook::API::Webhooks.show(uuid)
          # ::SNT::Webhook::API::Webhooks.create(params)
          # ::SNT::Webhook::API::Webhooks.update(uuid, params)
          # ::SNT::Webhook::API::Webhooks.destroy(uuid)
          def index(chain_uuid)
            api.get(path, {chain_uuid: chain_uuid})
          end

          def show(uuid)
            api.get(path(uuid))
          end

          def create(params)
            api.post(path, params)
          end
          
          def update(uuid, params)
            api.put(path(uuid), params)
          end

          def destroy(uuid)
            api.delete(path(uuid))
          end

          # ::SNT::Webhook::API::Webhooks.supporting_events
          def supporting_events
            api.get(path('supporting_events'))
          end

          # ::SNT::Webhook::API::Webhooks.delivery_types
          def delivery_types
            api.get(path('delivery_types'))
          end

         private

          def path(component = nil)
            RESOURCE_PATH.join(component.to_s).to_path
          end
        end
      end
    end
  end
end
