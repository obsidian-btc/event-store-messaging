require_relative 'spec_init'

describe "Stream Reader" do
  specify "Is actuated by the subscription's action block" do
    reader = Fixtures.reader

    subscription = EventStore::Client::HTTP::Subscription.new
    reader.subscription = subscription

    reader.configure_subscription_action

    data = { data: { foo: 'bar' }}

    reader.subscription.receive data

    assert(reader.read? data)
  end
end

