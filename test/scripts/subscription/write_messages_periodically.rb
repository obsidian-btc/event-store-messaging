require_relative './subscription_init'

stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testSubscription"
logger(__FILE__).info "Stream name: #{stream_name}"

stream_name_file = 'tmp/stream_name'
File.write stream_name_file, stream_name

at_exit do
  File.unlink stream_name_file
end

writer = EventStore::Messaging::Writer.build

period = ENV['PERIOD']
period ||= 200
period_seconds = Rational(period, 1000)

loop do
  message = EventStore::Messaging::Controls::Message.example(Clock::UTC.iso8601)

  result = writer.write message, stream_name

  logger(__FILE__).data result.inspect

  sleep period_seconds
end
