module SNT
  module Core
    module Services
      module Callbacks
        def on_error(*method_names)
          self.error_callbacks += method_names
        end

        def on_completion(*method_names)
          self.completion_callbacks += method_names
        end

        def error_callbacks
          @error_callbacks ||= []
        end

        def completion_callbacks
          @completion_callbacks ||= []
        end
      end
    end
  end
end
