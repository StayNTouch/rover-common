module SNT
  module Core
    module RPC
      class << self
        def included(klass)
          klass.send(:extend, ClassMethods)
        end
      end

      module ClassMethods
        # Sanitize options being sent to
        # SneakerPacker remote_call method.
        def compile_options(options)
          defaults = {
            timeout: nil
          }

          defaults.merge((options.is_a?(Hash) ? options : {}).delete_if { |k, _| !defaults.key?(k) }).compact
        end
      end
    end
  end
end
