require 'bunny'

module SNT
  module Core
    module MQ
      # = SNT MQ Publisher
      class Publisher
        # The Stayntouch publisher is library used to publish messages to message broker. This library
        # utilizes a single SNT configured AMPQ connection and channel. This is implemented using the Bunny gem.
        # Usage is quite simple and the only requirement is to configure SNT and call the publish message with
        # a payload and any bunny publish options. This publisher is Thread Safe.
        #
        # == Configuration
        #
        # Configuration
        #  ::SNT::Core::MQ.configure amqp: 'localhost',
        #                heartbeat: 2, # default
        #                log: 'log/snt.log',
        #                vhost: '/'
        #  ::SNT::Core::MQ.logger.level = Logger::INFO
        #
        # == Example
        #
        #  ::SNT::Core::MQ.publisher.publish('This is my message.')
        #
        # This will publish a message to the broker using the default exchange and no routing key.
        #
        # == Example with routing key
        #
        #  ::SNT::Core::MQ.publisher.publish('This is my message.', routing_key: 'example')
        #
        # == Example with named exchange
        #
        #  ::SNT::Core::MQ.publisher.publish('This is my message.', exchange: 'example', exchange_options: { type: :direct })
        #

        ERROR_MAX_RETRY_COUNT = 3

        def initialize
          @mutex = Mutex.new
        end

        def publish(msg, options = {})
          # Threadsafe publish
          @mutex.synchronize do
            error_retry_count = 0
            begin
              # Channel verification
              ensure_channel!

              # Check for targeted exchange, otherwise use the default
              exchange = if options[:exchange]
                           channel.exchange(options[:exchange], options[:exchange_options])
                         else
                           channel.default_exchange
                         end

              # Establish route
              to_queue = options.delete(:to_queue)
              options[:routing_key] ||= to_queue

              # Log the message being published with some context
              ::SNT::Core::MQ.logger.info "SNT::Publisher#publish on tid #{Thread.current.object_id} <#{msg}> to " /
                                          "[#{exchange.name}, #{options[:routing_key]}]"

              times = 0
              while times <= 3 do
                # Publish to RabbitMQ
                exchange.publish(msg, options)

                # Block until message is confirmed. If it fails, retry up to 3 times.
                if channel.wait_for_confirms
                  break
                else
                  times += 1

                  channel.nacked_set.each do |n|
                    ::SNT::Core::MQ.logger.error "publishing message with id #{n} to #{options[:routing_key]} was nacked by broker time(s) #{times}"
                  end
                end
              end
            rescue Bunny::ConnectionClosedError => e
              raise e if error_retry_count >= ERROR_MAX_RETRY_COUNT

              error_retry_count += 1

              ::SNT::Core::MQ.logger.warn "Rabbitmq connection is closed. Create connection and retry(#{error_retry_count}/#{ERROR_MAX_RETRY_COUNT})"

              Thread.current[:bunny_channel] = nil
              ::SNT::Core::MQ.reconnect!
              retry
            end
          end

          # Void the return
          nil
        # We must rescue all exceptions, so an issue with queuing system does not degrade the rest of the app
        rescue => e
          ::SNT::Core::MQ.logger.error "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
        end

        private

        # Check if we have a connection channel created yet and if it is open
        def ensure_channel!
          Thread.current[:bunny_channel] = nil unless channel && channel.open?
        end

        # Find or create the channel for the current thread we will be using for publishing
        def channel
          # This channel will be dedicated to this publisher
          # By default this is a ampq.fanout channel

          # Put channel in confirmation mode
          # http://www.rabbitmq.com/confirms.html
          Thread.current[:bunny_channel] ||= ::SNT::Core::MQ.connection.create_channel.tap(&:confirm_select)
        end
      end
    end
  end
end
