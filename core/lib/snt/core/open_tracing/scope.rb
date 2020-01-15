module SNT
  module Core
    module OpenTracing
      class Scope
        def initialize(span, scope_stack, finish_on_close:)
          @span = span
          @scope_stack = scope_stack
          @finish_on_close = finish_on_close
        end

        attr_reader :span

        def close
          @span.finish if @finish_on_close
          @scope_stack.pop
        end
      end
    end
  end
end
