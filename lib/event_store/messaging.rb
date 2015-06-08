require 'set_attributes'
require 'schema'
require 'telemetry/logger'
require 'inclusion'
require 'virtual'; Virtual.activate
require 'naught'
require 'dependency'; Dependency.activate
require 'casing'
require 'event_store/client/http/vertx'

require 'event_store/messaging/data_structure'
require 'event_store/messaging/message'
require 'event_store/messaging/registry'
require 'event_store/messaging/message_registry'
require 'event_store/messaging/handler'
require 'event_store/messaging/handler_registry'
require 'event_store/messaging/dispatcher'
require 'event_store/messaging/stream/entry'
require 'event_store/messaging/stream/reader'
