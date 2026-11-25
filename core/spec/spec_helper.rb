# Run from the repository root:
#
#   rspec -I core/lib -I core/spec core/spec
#
# The gem does not declare bunny as a runtime dependency (each service brings its own), so the
# specs need `bunny` and `rspec` installed locally.
require 'logger'
require 'json'
require 'bunny'
require 'snt/core/mq'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec) { |c| c.verify_partial_doubles = true }
  config.order = :random
end
