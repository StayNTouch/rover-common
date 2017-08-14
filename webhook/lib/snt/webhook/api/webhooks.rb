module SNT
  module Webhook
    module API
      class Webhooks < Base
        class << self
          # Define basic api methods
          #
          # ::SNT::Webhook::API::Webhooks.index(chain_uuid)
          # ::SNT::Webhook::API::Webhooks.show(uuid)
          # ::SNT::Webhook::API::Webhooks.create(params)
          # ::SNT::Webhook::API::Webhooks.update(uuid, params)
          #
          %w(index show create update).each do |method_name|
            define_method(method_name.to_sym) do |*args|
              api.call(method_name, args, namespace: :webhook, timeout: 60)
            end
          end

          # ::SNT::Webhook::API::Webhooks.supporting_events
          def supporting_events
            api.call('supporting_events', {}, namespace: :webhook, timeout: 60)
          end

          # ::SNT::Webhook::API::Webhooks.delivery_types
          def delivery_types
            api.call('delivery_types', {}, namespace: :webhook, timeout: 60)
          end
        end
      end
    end
  end
end
