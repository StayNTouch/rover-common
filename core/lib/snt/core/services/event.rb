module SNT
  module Core
    module Services
      class Event
        ##### Event trigger with initial event information to +service+.dto queue
        #
        # e.g.: ::SNT::Core::MQ.publisher.publish(+event_context+, routing_key: 'pms.dto')
        #
        ### Case #1: Normal Event with Object and attributes
        #
        #   event_args = {
        #     service: :pms,
        #     category: :reservation
        #     name: :update,
        #     data: {
        #       object: { type: 'Reservation', id: 123123 },
        #       attributes: { +attribute_info+ }
        #     }
        #
        #   ::SNT::Core::Services::Event.publish(event_args)
        #   # => nil
        #
        ### Case #2: Normal Event without Object
        #
        #   event_args = {
        #     service: :pms,
        #     category: :rate_manager,
        #     name: :update,
        #     data: {
        #       details: { +detail_info+ }
        #     }
        #
        #   ::SNT::Core::Services::Event.publish(event_args)
        #   # => nil
        #
        ### Case #3: Event with active_model
        #
        # ## PubSub::Notifier.pub_sub_notifier
        #
        #   event_args = {
        #     service: :pms,
        #     category: :active_model,
        #     name: :update,
        #     data: {
        #       object: { type: 'Reservation', id: 123123 },
        #       details: { +changes+ },
        #       attributes: { +attributes+ }
        #     }
        #
        #   ::SNT::Core::Services::Event.publish(event_args)
        #   # => nil
        #
        ### Case #4: Action events. This will just publish to pms.actions exchange directly
        #
        #   event_args = {
        #     service: :pms,
        #     category: :action,
        #     name: :action,
        #     data: {
        #       object: { type: 'Action', id: 123123 },
        #       details: {
        #         action_type: Symbol,
        #         details: Hash,
        #         hotel_id: Integer,
        #         hotel_code: String,
        #         object_id: Integer,
        #         object_type: String
        #       }
        #     }
        #
        #   ::SNT::Core::Services::Event.publish(event_args)
        #   # => nil
        #
        attr_accessor :category, :data, :name, :service, :published

        def self.publish(args)
          new(args).publish
        end

        def initialize(args = {})
          args.each { |key, value| instance_variable_set("@#{key}", value) }
          @published = false
        end

        ##### Arguments for event context
        #
        # service: App/Service who published Event
        #        e.g.) pms, ifc, webhook
        #
        # category: Area that events belongs to some like Object, Module
        #         e.g.) reservation, rate_manager, action
        #
        # name: name of event
        #      e.g.) update, create, checkin, checkout
        #
        # data: free form for detail information
        #
        def event_context
          {
            service: service,
            category: category,
            name: name,
            data: data,
            timestamp: Time.now.utc,
            uuid: SecureRandom.uuid
          }
        end

        # Use EventPublisherWorker to format event message and publish to RabbitMQ
        def publish
          raise 'Event already published' if published

          begin
            ::SNT::Core::MQ.publisher.publish(event_context.to_json, routing_key: "#{service}.dto")
            self.published = true
          rescue => e
            logger.error "Could not publish service event to RabbitMQ: #{e.message}"
            logger.error e.backtrace
          end
        end
      end
    end
  end
end
