# require_relative '../message_init'

# describe "Proceed from Previous Message" do
#   let(:source) { EventStore::Messaging::Controls::Message.example }
#   let(:msg) { source.class.new }

#   let(:source_metadata) { source.metadata }
#   let(:metadata) { msg.metadata }

#   before do
#     EventStore::Messaging::Message::Proceed.(source, msg)
#   end

#   context "Copied attributes" do
#     specify "Copies the causation event URI" do
#       assert(metadata.causation_event_uri == source_metadata.source_event_uri)
#     end

#     specify "Copies the correlation stream name" do
#       assert(metadata.correlation_stream_name == source_metadata.correlation_stream_name)
#     end

#     specify "Copies the reply stream name" do
#       assert(metadata.reply_stream_name == source_metadata.reply_stream_name)
#     end
#   end

#   context "Attributes not copied" do
#     specify "Does not copy the source event URI" do
#       assert(metadata.source_event_uri.nil?)
#     end

#     specify "Does not copy the schema version" do
#       assert(metadata.schema_version.nil?)
#     end
#   end
# end
