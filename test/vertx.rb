require_relative 'test_init'

Runner.! 'vertx/**/*.rb' do |exclude|
  exclude =~ /(_init.rb|\.sketch.rb)\z|verticles/
end

Vertx.set_timer(1500) do
  Vertx.exit
end
