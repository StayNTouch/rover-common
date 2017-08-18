class SNT::Core::Services::Base
  delegate :new_error, :add_validation_error, :add_validation_errors, :add_active_record_errors, :merge_result, :publish_events, to: :result

  # Provide class level call method as convenience over calling new, then call
  def self.call(*args, &block)
    new(*args, &block).call
  end

  # @params
  # - options [Hash] attributes:
  #   - no_transaction [boolean] Do not start a transaction
  # @return [Services::Result]
  def call(options = {})
    if options[:no_transaction]
      # Don't start a transaction if no_transaction is true
      call_delegate
    else
      # Start a transaction around the service call. Use requires_new to ensure sub transactions can be rolled back without impacting parent
      # transaction. Services can optionally be invalidated and its transaction rolled back, when a sub-service fails and its sub-transaction is
      # rolled back.
      ActiveRecord::Base.transaction(requires_new: true) do
        call_delegate
      end
    end

    publish_events if ActiveRecord::Base.connection.open_transactions.zero? && result.status

    result
  rescue SNT::Core::Services::InvalidException
    result
  rescue ActiveRecord::RecordInvalid => e
    add_active_record_errors(e.record)
    result
  end

  # All services should override call_delegate
  def call_delegate; end

  # Add a validation error (if present) and raise an invalid exception
  def invalidate!(message = nil)
    add_validation_error(message) if message.present?
    raise SNT::Core::Services::InvalidException
  end

  def result
    @result ||= SNT::Core::Services::Result.new
  end

  # Merge another service's result object with this service's result. Invalidate if errors exist.
  def merge_result!(other_result)
    merge_result(other_result)
    invalidate! unless result.status
  end
end
