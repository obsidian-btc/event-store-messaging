require 'set_attributes'
require 'schema'
require 'telemetry/logger'
require 'inclusion'
require 'virtual'; Virtual.activate
require 'dependency'; Dependency.activate
require 'casing'

require 'event_store/client/http'

require 'event_store/messaging/message/metadata'
require 'event_store/messaging/message'
require 'event_store/messaging/registry'
require 'event_store/messaging/message_registry'
require 'event_store/messaging/handler'
require 'event_store/messaging/handler_registry'
require 'event_store/messaging/dispatcher'
require 'event_store/messaging/stream_name'

require 'event_store/messaging/message/export/event_data'
require 'event_store/messaging/message/import/event_data'

require 'event_store/messaging/writer'
require 'event_store/messaging/message_reader'
require 'event_store/messaging/reader'
require 'event_store/messaging/subscription'
