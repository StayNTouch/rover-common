module SNT
  module Core
    module OpenTracing
      class ScopeStack
        KEY = :__snt_scope_stack

        def push(scope)
          scopes << scope
        end

        def pop
          scopes.pop
        end

        def last
          scopes.last
        end

        private

        def scopes
          Thread.current[KEY] ||= []
        end
      end
    end
  end
end
