# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-messaging'
  s.summary = 'Messaging primitives for EventStore using the EventStore Client HTTP library'
  s.version = '0.3.0.1'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'event_store-client-http'
  s.add_runtime_dependency 'telemetry'
  s.add_runtime_dependency 'serialize'

  s.add_development_dependency 'process_host'
  s.add_development_dependency 'test_bench'
end
