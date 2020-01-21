module SNT
  module Core
    module OpenTracing
      class ScopeStack
        KEY = :__snt_scope_stack

        delegate :last, :pop, to: :scopes

        def push(scope)
          scopes << scope
        end

        private

        def scopes
          Thread.current[KEY] ||= []
        end
      end
    end
  end
end
