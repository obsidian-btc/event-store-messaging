require_relative '../test_init'

require 'vertx'
require 'event_store/client/http/controls'

def assert(val, message=nil)
  logger = logger(caller[0])
  if val
    logger.pass(message || 'Passed')
  else
    logger.fail(message || 'Failed')
    raise "Failed: #{caller[0]}"
  end
end
