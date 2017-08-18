class SNT::Core::Services::Result
  attr_accessor :data, :errors, :warnings, :events

  def initialize
    @data = {}
    @errors = []
    @warnings = []
    @events = []
  end

  def add_validation_error(message)
    @errors << Services::Error.new_validation_error(message)
  end

  def add_validation_errors(messages)
    messages.each { |message| add_validation_error(message) }
  end

  def add_active_record_errors(record)
    add_validation_errors(record.errors.full_messages)
  end

  def status
    @errors.blank?
  end

  def to_hash
    { status: status, data: data, errors: errors.map(&:to_hash) }
  end

  def formatted_errors
    error_messages.join('; ')
  end

  def error_messages
    errors.map(&:message)
  end

  # Merge another service's result object with this one for the errors, warnings, and events
  def merge(result)
    self.errors += result.errors
    self.warnings += result.warnings
    self.events += result.events
  end

  # Get a list of only the unpublished events
  def unpublished_events
    events.reject(&:published)
  end

  # Publish the events to RabbitMQ. This should only be done once the transaction is committed successfully and service is successful.
  def publish_events
    raise 'Cannot publish events unless service is successful' unless result.status
    unpublished_events.each(&:publish)
  end
end
