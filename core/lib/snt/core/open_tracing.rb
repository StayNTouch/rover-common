module SNT
  module Core
    module OpenTracing
      # snt/core/open_tracing/tracer is an implementation of OpenTracing Tracer (https://opentracing.io/docs/overview/tracers/).
      # Here is how it would be used:
      # In IFC/PMS (config/application.rb) we would set the global tracer of OpenTracing to SNT custom implementation of OpenTracing Tracer:
      #     ::OpenTracing.global_tracer = ::SNT::Core::OpenTracing::Tracer.new
      #
      # We also have an option to use Elastic-APM Tracer instead of our customer Tracer, simply replace the line mentioned above with:
      #     ::OpenTracing.global_tracer = ElasticAPM::OpenTracing::Tracer.new
      # Please make sure to review snt/core/open_tracing/gem_ext.rb if you want to use ElasticAPM Tracer.
      # There are some parts of the code in gem_ext.rb file that needs to be uncommented for supporting ElasticAPM Tracer
      # the gem_ext.rb is there to extend OpenTracing implementation by adding some methods to the module to make Logging Traces/Spans easier
      require 'snt/core/open_tracing/tracer'
    end
  end
end
