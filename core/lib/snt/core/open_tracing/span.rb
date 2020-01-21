require 'securerandom'
module SNT
  module Core
    module OpenTracing
      class Span
        # { context:
        #   {
        #     trace_context : {
        #       trace_id : @trace_id,
        #       parent_id : @parent_id,
        #       id : @id
        #     }
        #   }
        # }
        SpanContext = Struct.new(:trace_context)
        TraceContext = Struct.new(:trace_id, :parent_id, :id)

        def initialize(
            name = nil,
            parent_id = nil,
            trace_id = nil,
            id = nil
        )
          @name = name
          @trace_id =  trace_id ? trace_id : SecureRandom.hex(13)
          @parent_id = parent_id
          @id = id ? id : SecureRandom.hex(9)

          trace_context = TraceContext.new(@trace_id, @parent_id, @id)
          @context = SpanContext.new(trace_context)
        end

        attr_reader :id, :trace_id, :parent_id, :context

        def finish
          # no operation
        end

        def self.to_header(trace_context)
          format('%<trace_id>s-%<parent_id>s-%<id>s', trace_id: trace_context.trace_id, parent_id: trace_context.parent_id, id: trace_context.id)
        end

        def self.parse(header)
          return unless header
          trace_id, parent_id, id = header.split('-')
          Span.new('parsed-span', parent_id, trace_id, id)
        end
      end
    end
  end
end
