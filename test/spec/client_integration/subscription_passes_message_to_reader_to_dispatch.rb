require_relative 'client_integration_init'

describe "Stream Reader" do
  specify "Is actuated by the subscription's action block" do
    reader = Fixtures.reader

    subscription = EventStore::Client::HTTP::Vertx::Subscription.new

    subscription.action = reader.action

    reader.subscription = subscription

    data = { data: { foo: 'bar' }}

    subscription.receive data

    assert(reader.read? data)
  end
end

