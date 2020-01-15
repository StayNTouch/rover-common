require 'snt/core/open_tracing/span'
require 'snt/core/open_tracing/scope_manager'
module SNT
  module Core
    module OpenTracing
      class Tracer
        HEADER_NAME = 'snt-traceparent'.freeze

        def initialize
          @scope_manager = ScopeManager.new
        end

        attr_reader :scope_manager

        def active_span
          scope_manager.active.span if scope_manager.active
        end

        def start_active_span(
            operation_name,
            child_of: nil,
            ignore_active_scope: false,
            finish_on_close: true,
            **
        )
          span = start_span(
            operation_name,
            child_of: child_of,
            ignore_active_scope: ignore_active_scope
          )
          scope = scope_manager.activate(span, finish_on_close: finish_on_close)

          if block_given?
            begin
              yield scope
            ensure
              scope.close
            end
          end

          scope
        end

        def start_span(
            operation_name,
            child_of: nil,
            ignore_active_scope: false,
            **
        )
          span_context = prepare_span_context(
            child_of: child_of,
            ignore_active_scope: ignore_active_scope
          )

          trace_context = span_context && span_context.respond_to?(:trace_context) && span_context.trace_context
          trace_context ? Span.new(operation_name, trace_context.id, trace_context.trace_id) : Span.new(operation_name)
        end

        # rubocop:enable Metrics/ParameterLists

        def inject(trace_context, format, carrier)
          case format
          when ::OpenTracing::FORMAT_RACK
            carrier[HEADER_NAME] = Span.to_header(trace_context)
          else
            warn 'Only injection via HTTP headers and Rack is available'
          end
        end

        def extract(format, carrier)
          case format
          when ::OpenTracing::FORMAT_RACK
            Span.parse(carrier[HEADER_NAME])
          else
            warn 'Only extraction from HTTP headers via Rack is available'
            nil
          end
        end

        private

        def prepare_span_context(
            child_of:,
            ignore_active_scope:
        )
          context_from_child_of(child_of) || context_from_active_scope(ignore_active_scope)
        end

        def context_from_child_of(child_of)
          return unless child_of
          child_of.respond_to?(:context) ? child_of.context : child_of
        end

        def context_from_active_scope(ignore_active_scope)
          return if ignore_active_scope
          @scope_manager.active.span.context if @scope_manager.active && @scope_manager.active.span
        end
      end
    end
  end
end
