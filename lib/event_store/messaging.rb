require 'set_attributes'
require 'schema'
require 'telemetry/logger'
require 'inclusion'
require 'virtual'; Virtual.activate
require 'dependency'; Dependency.activate

require 'event_store'
require 'event_store/client/http/vertx'

require 'event_store/messaging/message'
require 'event_store/messaging/message/conversion/event_data'
require 'event_store/messaging/message/conversion/stream_entry'
require 'event_store/messaging/registry'
require 'event_store/messaging/message_registry'
require 'event_store/messaging/handler'
require 'event_store/messaging/handler_registry'
require 'event_store/messaging/dispatcher'
require 'event_store/messaging/reader'
require 'event_store/messaging/writer'
