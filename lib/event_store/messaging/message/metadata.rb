# TODO Causation id need to be set to previous message id [Scott, Tue Jun 23 2015]

module EventStore
  module Messaging
    module Message
      class Metadata
        include Schema::DataStructure

        attribute :id

        attribute :source_stream # from streamId in stream entry data
        attribute :source_id # from streamId in stream entry data

        attribute :correlation_stream
        attribute :correlation_id

        attribute :causation_stream
        attribute :causation_id

        attribute :reply_stream
        attribute :reply_id

#---
# maybe
        attribute :type
        attribute :name
#---

        # def type
        #   puts "!!! WARN: type not implemented - it will be an attribute (Messsage::Metadata)"
        #   # NOTE: Delegate from message instance interface
        # end
        # def name
        #   puts "!!! WARN: name not implemented - it will be an attribute (Messsage::Metadata)"
        #   # NOTE: Delegate from message instance interface
        # end
      end
    end
  end
end
