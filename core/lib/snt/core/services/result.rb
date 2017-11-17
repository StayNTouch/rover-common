module SNT
  module Core
    module Services
      class Result
        attr_accessor :data, :errors, :warnings, :events

        WARNING = 'WARNING'.freeze

        def initialize
          @data = {}
          @errors = []
          @warnings = []
          @events = []
        end

        def add_warning(message, code = WARNING)
          @warnings << Warning.new_warning(code, message)
        end

        def add_error(code, message)
          @errors << Error.new_error(code, message)
        end

        def add_validation_error(message)
          @errors << Error.new_validation_error(message)
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

        # Add a validation error (if present) and raise an invalid exception
        def invalidate!(message = nil)
          add_validation_error(message) if message.present?
          raise InvalidException
        end

        # Merge another service's result object with this one for the errors, warnings, and events
        def merge_result(other_result, options = {})
          self.errors += other_result.errors unless options[:ignore_errors]
          self.warnings += other_result.warnings
          self.events += other_result.events

          other_result
        end

        # Merge another service's result object with this service's result. Invalidate unless this service status is true.
        def merge_result!(other_result, options = {})
          merge_result(other_result, options)
          invalidate! unless status

          other_result
        end

        # Get a list of only the unpublished events
        def unpublished_events
          events.reject(&:published)
        end

        # Publish the events to RabbitMQ. This should only be done once the transaction is committed successfully and service is successful.
        def publish_events
          raise 'Cannot publish events unless service is successful' unless status
          unpublished_events.each(&:publish)
        end
      end
    end
  end
end
