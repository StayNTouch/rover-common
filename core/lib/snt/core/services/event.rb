class SNT::Core::Services::Event
  attr_accessor :hotel, :object, :action_type, :details, :published

  def initialize(args)
    @published = false
    args.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def event_data
    {
      action_type: action_type,
      details: details,
      hotel_id: hotel.id,
      hotel_code: hotel.code,
      object_id: object.id,
      object_type: object.class.name
    }
  end

  # Publish the event to RabbitMQ exchange for 'pms.actions' and routing_key same as the action_type. Fail if event already published.
  def publish
    raise 'Event already published' if published

    begin
      ::SNT::Core::MQ.publisher.publish(event_data.to_json, exchange: 'pms.actions', exchange_options: { type: :direct, durable: true },
                                                            routing_key: action_type.to_s.downcase)

      self.published = true
    rescue => e
      logger.error "Could not publish service event to RabbitMQ: #{e.message}"
      logger.error e.backtrace
    end
  end
end
