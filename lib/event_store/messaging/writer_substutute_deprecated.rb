class Substitute
  attr_accessor :stream_version

  dependency :writer
  dependency :telemetry, Telemetry

  def self.build
    new.tap do |instance|
      instance.writer = EventStore::Messaging::Writer.new
      ::Telemetry.configure instance
    end
  end

  def messages
    @messages ||= Hash.new do |hash, stream_name|
      hash[stream_name] = []
    end
  end

  def write(message, stream_name, expected_version: nil, reply_stream_name: nil)
    if stream_version && expected_version && expected_version != stream_version
      raise EventStore::Client::HTTP::Request::Post::ExpectedVersionError
    end

    writer.write(message, stream_name, reply_stream_name: reply_stream_name).tap do
      messages[stream_name] << message
      telemetry.record :written, Telemetry::Data.new(stream_name, message)
    end
  end

  def reply(message)
    reply_stream_name = message.metadata.reply_stream_name
    result = writer.reply(message)
    messages[reply_stream_name] << message
    telemetry.record :replied, Telemetry::Data.new(reply_stream_name, message)
    message
  end

  def written?(message=nil, stream_name=nil, &predicate)
    if predicate.nil?
      predicate = Proc.new { |m| m == message }
    end

    if stream_name
      messages[stream_name].any? &predicate
    else
      messages.each_key do |stream_name|
        return true if written? message, stream_name, &predicate
      end
      false
    end
  end
end
