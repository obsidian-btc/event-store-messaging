require 'dependency'
Dependency.activate

require 'telemetry/logger'
require 'uuid'
require 'settings'
Settings.activate

require 'event_store/client/http/subscription'
