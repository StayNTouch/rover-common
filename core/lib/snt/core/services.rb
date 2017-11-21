module SNT
  module Core
    module Services
      autoload :Base, 'snt/core/services/base'
      autoload :Callbacks, 'snt/core/services/callbacks'
      autoload :Error, 'snt/core/services/error'
      autoload :Warning, 'snt/core/services/warning'
      autoload :Message, 'snt/core/services/message'
      autoload :Event, 'snt/core/services/event'
      autoload :InvalidException, 'snt/core/services/invalid_exception'
      autoload :Result, 'snt/core/services/result'
      autoload :SlaveGroup, 'snt/core/services/slave_group'
    end
  end
end
