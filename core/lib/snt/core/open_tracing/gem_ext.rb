require 'elastic_apm/opentracing'
# This module extends OpenTracing implementation by adding methods defined here
module OpenTracing
  # Starts a new active span by using the provided header that contains the injected trace info
  # if header is nil, it will create a new span and trace. if the header is provided , it will create a child span
  def self.start_span_of_header(span_name, header = nil)
    set_global_tracer_to_elastic
    parent_span = nil
    if header && !header.empty?
      trace_context = ::OpenTracing.extract(::OpenTracing::FORMAT_RACK, header.stringify_keys)
      parent_span = ElasticAPM::OpenTracing::SpanContext.from_trace_context(trace_context)
    end
    start_span_with_logging(span_name, parent_span) do |scope|
      yield scope
    end
  end

  # Creates a new active span based on a parent span if provided. if child_of is nil, it will create a new span and trace
  def self.start_span_with_logging(span_name, child_of = nil)
    set_global_tracer_to_elastic
    scope = ::OpenTracing.start_active_span(span_name, child_of: child_of)
    span = scope.span
    original_mdc_trace = ::Logging.mdc['trace']
    original_mdc_parent_span = ::Logging.mdc['parent_span']
    original_mdc_span = ::Logging.mdc['span']
    ::Logging.mdc['trace'] = span.context.trace_context.trace_id
    ::Logging.mdc['parent_span'] = span.context.trace_context.parent_id
    ::Logging.mdc['span'] = span.context.trace_context.id
    yield scope
    ::Logging.mdc['trace'] = original_mdc_trace
    ::Logging.mdc['parent_span'] = original_mdc_parent_span
    ::Logging.mdc['span'] = original_mdc_span
    scope.close
  end

  # Gets the current active span in current scope and returns a trace object based on that
  def self.current_trace_object
    set_global_tracer_to_elastic
    span = ::OpenTracing.scope_manager.active.span if ::OpenTracing.scope_manager.active
    {}.tap do |trace_obj|
      if span
        ::OpenTracing.inject(span.context.trace_context, ::OpenTracing::FORMAT_RACK, trace_obj)
        # need to map to the hash key that the `extract` method expects in the destination
        trace_obj["HTTP_#{trace_obj.keys.first.upcase.tr('-', '_')}"] = trace_obj.delete(trace_obj.keys.first)
      end
    end
  end

  # We need to make sure that Global Tracer for OpenTracing is set to ElasticAPM Tracer. This is basically called in the beginning
  # of all methods extended in this module. The reason we set the global tracer here is because for some unknown reasons (possibly process forking)
  # the global tracer is not set when we call into the extended methods in this module even when
  # we set it in application.rb or initializers in IFC or PMS
  def self.set_global_tracer_to_elastic
    return if ::OpenTracing.global_tracer.instance_of?(::ElasticAPM::OpenTracing::Tracer)

    ::OpenTracing.global_tracer = ElasticAPM::OpenTracing::Tracer.new
  end
end
