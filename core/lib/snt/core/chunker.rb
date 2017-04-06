require 'thread'
module SNT
  module Core
    # This class is used to concurrently process work on an array via a thread pool. This library
    # will divide the work amongst a provide pool size.
    #
    # Example:
    #
    #   counter = 0
    #   ::SNT::Core::Chunker.new(10).process!((1..1000)) { |i| counter += 1 }
    #   puts counter
    #
    class Chunker
      def initialize(pool_size = 10)
        @pool_size = pool_size
        @pool = []
      end

      def process!(data, &block)
        Array(data).each_slice(@pool_size) do |slice|
          slice.each do |item|
            @pool << Thread.new { block.call(item) }
          end
          @pool.map { |p| p.join }
          @pool = []
        end
      end
    end
  end
end
