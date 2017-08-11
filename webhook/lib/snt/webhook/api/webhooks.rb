module SNT
  module Webhook
    module API
      class Webhooks < Base
        class << self
          # ::SNT::Webhook::API::Webhooks.index(chain_uuid)
          def index(*args)
            api.call('index', args, namespace: :webhook, timeout: 60)
          end

          # ::SNT::Webhook::API::Webhooks.show(uuid)
          def show(*args)
            api.call('show', args, namespace: :webhook, timeout: 60)
          end

          # ::SNT::Webhook::API::Webhooks.create(params)
          def create(*args)
            api.call('create', args, namespace: :webhook, timeout: 60)
          end

          # ::SNT::Webhook::API::Webhooks.update(uuid, params)
          def update(*args)
            api.call('update', args, namespace: :webhook, timeout: 60)
          end

          # ::SNT::Webhook::API::Webhooks.supporting_events
          def supporting_events
            api.call('supporting_events', {}, namespace: :webhook, timeout: 60)
          end
        end
      end
    end
  end
end
