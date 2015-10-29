# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-messaging'
  s.summary = 'Messaging primitives for EventStore using the EventStore Client HTTP library'
  s.version = '0.1.3'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'controls'
  s.add_runtime_dependency 'dependency'
  s.add_runtime_dependency 'event_store-client-http'
  s.add_runtime_dependency 'set_attributes'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'telemetry-logger'
  s.add_runtime_dependency 'virtual'

  s.add_development_dependency 'process_host'
  s.add_development_dependency 'runner'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-spec-context'
  s.add_development_dependency 'pry'
end
