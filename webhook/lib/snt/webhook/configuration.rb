require 'singleton'

module SNT
  module Webhook
    class Configuration
      include Singleton

      attr_accessor :api_endpoint, :api_strategy, :open_timeout, :read_timeout

      def self.defaults
        @defaults ||= {
          api_endpoint: nil,
          open_timeout: 5,
          read_timeout: 5
        }
      end

      def initialize
        self.class.defaults.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end

    def self.config
      Configuration.instance
    end

    def self.configure
      yield config
    end
  end
end
