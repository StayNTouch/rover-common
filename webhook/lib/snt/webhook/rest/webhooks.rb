require 'snt/webhook/rest/base'

module SNT
  module Webhook
    module REST
      class Webhooks < SNT::Webhook::REST::Base
        resource :webhook

        def list(params = {})
          get(path, params)
        end

        def create(params)
          post(path, params)
        end

        def retrieve(uuid)
          get(path(uuid))
        end

        def update(uuid, params)
          put(path(uuid), params)
        end

        def delete(uuid)
          super(path(uuid))
        end

        def supporting_events
          get(path('supporting_events'))
        end

        def delivery_types
          get(path('delivery_types'))
        end
      end
    end
  end
end
