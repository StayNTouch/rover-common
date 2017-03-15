require 'snt/core'

module SNT
  module PMS
    require 'snt/pms/core_ext'
    require 'snt/pms/errors'

    autoload :Configuration, 'snt/pms/configuration'
    autoload :API, 'snt/pms/api'
    autoload :REST, 'snt/pms/rest'
    autoload :RPC, 'snt/pms/rpc'

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
