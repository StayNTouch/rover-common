module SNT
  module Core
    module MQ; end
  end
end

require 'snt/core/mq/configuration'
require 'snt/core/mq/publisher'

module SNT
  module Core
    module MQ
      extend self

      CONFIG = Configuration.new

      def connection
        @connection || establish_connection!
      end

      def clear!
        CONFIG.clear
        @logger = nil
        @connection = nil
        @publisher = nil
        @configured = false
      end

      # Supports all bunny configuration values
      # http://rubybunny.info/articles/connecting.html
      def configure(opts = {})
        CONFIG.merge!(opts)
        setup_general_logger!

        setup_general_publisher!
        @configured = true
      end

      def configured?
        @configured ? true : false
      end

      def logger=(logger)
        @logger = logger
      end

      def logger
        @logger
      end

      def publisher
        @publisher
      end

      def reconnect!
        @connection.close
        establish_connection!
      end

      private

      # Create a global Bunny connection
      def establish_connection!
        parameters = CONFIG.merge!(logger: ::SNT::Core::MQ.logger)

        @connection = Bunny.new(parameters[:amqp], parameters).tap(&:start)
      end

      def setup_general_logger!
        if [:info, :debug, :error, :warn].all? { |meth| CONFIG[:log].respond_to?(meth) }
          @logger = CONFIG[:log]
        else
          @logger = ::Logger.new(CONFIG[:log])
          @logger.level = ::Logger::WARN
        end
      end

      # Create a global publisher
      def setup_general_publisher!
        @publisher = Publisher.new
      end
    end
  end
end
