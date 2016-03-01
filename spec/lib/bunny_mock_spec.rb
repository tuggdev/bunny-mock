require 'spec_helper'

describe "BunnyMock Integration Tests", :integration => true do

  it "should handle the basics of message passing" do
    # Basic one-to-one queue/exchange setup.
    bunny = BunnyMock::Bunny.new

    queue = BunnyMock::Bunny.queue('integration_queue', { durable: true, auto_delete: true,
                                                          exclusive: false,
                                                          arguments: { 'x-ha-policy' => 'all' } })

    exchange = BunnyMock::Bunny.exchange(bunny.create_channel, :direct, 'integration_exchange',
                                         { durable: true, auto_delete: true })

    queue.bind(exchange)

    # Basic assertions
    expect(queue.messages).to be_empty
    exchange.queues.should have(1).queue
    exchange.should be_bound_to "integration_queue"
    queue.default_consumer.message_count.should == 0

    # # Send some messages
    exchange.publish("Message 1")
    exchange.publish("Message 2")
    exchange.publish("Message 3")

    # # Verify state of the queue
    queue.messages.should have(3).messages
    queue.messages.should == [
      "Message 1",
      "Message 2",
      "Message 3"
    ]

    # # Here's what we expect to happen when we subscribe to this queue.
    handler = double("target")
    handler.should_receive(:handle_message).with("Message 1").ordered
    handler.should_receive(:handle_message).with("Message 2").ordered
    handler.should_receive(:handle_message).with("Message 3").ordered

    # # Read all those messages
    msg_count = 0
    queue.subscribe do |msg|
      handler.handle_message(msg[:payload])
      msg_count += 1
      queue.default_consumer.message_count.should == msg_count
    end
  end

end