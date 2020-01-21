require 'snt/core/open_tracing/scope'
require 'snt/core/open_tracing/scope_stack'
module SNT
  module Core
    module OpenTracing
      class ScopeManager
        def initialize
          @scope_stack = ScopeStack.new
        end

        def activate(span, finish_on_close: true)
          return active if active && active.span == span

          scope = Scope.new(span, @scope_stack, finish_on_close: finish_on_close)
          @scope_stack.push scope
          scope
        end

        def active
          @scope_stack.last
        end
      end
    end
  end
end
