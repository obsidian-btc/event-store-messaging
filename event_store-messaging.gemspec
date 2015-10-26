# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-messaging'
  s.summary = 'Coordinates messaging with Event Store'
  s.version = '0.1.1'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'set_attributes'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'telemetry-logger'
  s.add_runtime_dependency 'virtual'
  s.add_runtime_dependency 'dependency'
  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'event_store-client-http'
end