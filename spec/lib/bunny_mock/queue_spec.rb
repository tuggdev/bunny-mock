require 'spec_helper'

describe BunnyMock::Queue do
  let(:queue_name) { "my_test_queue" }
  let(:queue_attrs) {
    {
      :durable     => true,
      :auto_delete => true,
      :exclusive   => false,
      :arguments   => {"x-ha-policy" => "all"}
    }
  }
  let(:queue) { BunnyMock::Queue.new(queue_name, queue_attrs) }

  describe "#name" do
    it "is consistent" do
      expect(queue.name).to eq(queue_name)
    end
  end

  describe "#attrs" do
    it "are consistent" do
      expect(queue.attrs).to eq(queue_attrs)
    end
  end

  describe "#messages" do
    it "is an Array" do
      expect(queue.messages).to be_an(Array)
    end

    it "should be empty" do
      expect(queue.messages).to be_empty
    end
  end

  describe "#messages" do
    it "is an Array" do
      expect(queue.messages).to be_an(Array)
    end

    it "should be empty" do
      expect(queue.messages).to be_empty
    end
  end

  describe "#delivery_count" do
    it "is initialized to zero" do
      expect(queue.delivery_count).to eq(0)
    end
  end

  describe "#subscribe" do

    let(:handler) { double("handler") }

    before(:each) do
      queue.messages = ["Ehh", "What's up Doc?"]
      handler.should_receive(:handle).with("Ehh").ordered
      handler.should_receive(:handle).with("What's up Doc?").ordered
      queue.subscribe { |msg| handler.handle(msg[:payload]) }
    end

    it "#messages are empty" do
      expect(queue.messages).to be_empty
    end

    it "#messages are empty" do
      expect(queue.messages).to be_empty
    end

    it "#delivery_count is accurate" do
      expect(queue.delivery_count).to eq(2)
    end

    it "verifies the mocks for rspec" do
      verify_mocks_for_rspec
    end

  end

  describe "#bind" do

    let(:channel) { BunnyMock::Channel.new }
    let(:type) { :direct }
    let(:name) { 'my_test_exchange' }
    let(:exchange) { BunnyMock::Exchange.new(channel, type, name) }

    before(:each) { queue.bind(exchange) }

    it "is bound" do
      exchange.should be_bound_to "my_test_queue"
    end

  end

  describe "#default_consumer" do

    let(:delivery_count) { 5 }
    let(:consumer) { queue.default_consumer }
    before(:each) do
      queue.delivery_count = delivery_count
    end

    it "is the correct class" do
      expect(consumer).to be_a(BunnyMock::Consumer)
    end

    it "has a consistent message_count" do
      expect(consumer.message_count).to eq(delivery_count)
    end

  end

  describe "#method_missing" do

    it "queue is durable" do
      expect(queue).to be_durable
    end

    it "queue is auto_delete" do
      expect(queue.auto_delete).to be_true
    end

    it "queue is NOT exclusive" do
      expect(queue.exclusive).to be_false
    end

    it "queue arguments are consistent" do
      expect(queue.arguments).to eq({"x-ha-policy" => "all"})
    end

    it "raises a NoMethodError error for an unhandled method" do
      expect{queue.wtf}.to raise_error(NoMethodError)
    end

  end

end