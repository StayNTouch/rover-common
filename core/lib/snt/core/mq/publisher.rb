require 'bunny'

module SNT
  module Core
    module MQ
      # = SNT Publisher
      class Publisher
        # The Stayntouch publisher is library used to publish messages to message broker. This library
        # utilizes a single SNT configured AMPQ connection and channel. This is implemented using the Bunny gem.
        # Usage is quite simple and the only requirement is to configure SNT and call the publish message with
        # a payload and any bunny publish options.
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

        def initialize
          @mutex = Mutex.new
        end

        def publish(msg, options = {})
          # Threadsafe publish
          @mutex.synchronize do
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

            ::SNT::Core::MQ.logger.info "SNT::Publisher#publish on tid #{Thread.current.object_id} <#{msg}> to [#{options[:routing_key]}]"

            times = 0
            while times <= 3 do
              exchange.publish(msg, options)

              # Block until all messages have been confirmed
              if channel.wait_for_confirms
                break
              else
                times += 1

                channel.nacked_set.each do |n|
                  ::SNT::Core::MQ.logger.error "publishing message with id #{n} to #{options[:routing_key]} was nacked by broker time(s) #{times}"
                end
              end
            end
          end

          # Void the return
          nil
          # We must rescue all exceptions, so an issue with queuing system does not degrade the rest of the app
        rescue => e
          ::SNT::Core::MQ.logger.error "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
        end

        private

        def ensure_channel!
          channel && channel.open?
        end

        def channel
          # This channel will be dedicated to this publisher
          # By default this is a ampq.fanout channel

          # Put channel in confirmation mode
          # http://www.rabbitmq.com/confirms.html
          Thread.current[:bunny_channel] ||= ::SNT::Core::MQ.connection.create_channel.tap(&:confirm_select)
        end
        #
        # def thread
        #   Thread.current[:"snt_publisher_#{self.object_id}"] ||= {}
        # end
      end
    end
  end
end
