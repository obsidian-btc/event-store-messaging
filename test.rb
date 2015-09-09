require_relative 'test/test_init'

Runner.! 'test/spec/**/*.rb' do |exclude|
  exclude =~ /spec\.rb|(_init.rb|\.scratch.rb|\.skip\.rb)\z/
end
