require_relative 'test_init'

Runner.! 'spec/*.rb' do |exclude|
  exclude =~ /spec_init.rb\z/
end
