module SNT
  module Webhook
    class Configuration
      attr_accessor :api_endpoint, :open_timeout, :read_timeout

      def self.defaults
        @defaults ||= {
          api_endpoint: nil,
          open_timeout: 5,
          read_timeout: 5
        }
      end

      def initialize
        self.class.defaults.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end
  end
end
