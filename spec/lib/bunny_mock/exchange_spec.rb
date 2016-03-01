require 'spec_helper'

describe BunnyMock::Exchange do

  let(:channel)         { BunnyMock::Channel.new }
  let(:type)            { :direct }
  let(:name)            { "my_test_exchange" }
  let(:exchange_attrs)  {  { durable: true, auto_delete: true } }

  subject(:exchange) { BunnyMock::Exchange.new(channel, type, name, exchange_attrs) }

  describe "#name" do

    it "returns the name" do
      expect(exchange.name).to eq(name)
    end

  end

  describe "#attrs" do

    it "returns the attributes" do
      expect(exchange.attrs).to eq(exchange_attrs)
    end

  end

  describe "#queues" do

    context "when the exchange is not bound to any queues" do
      it "is an Array" do
        expect(exchange.queues).to be_an(Array)
      end

      it "is empty" do
        expect(exchange.queues).to be_empty
      end
    end

    context "when the exchange is bound to a queue" do
      let(:queue) { BunnyMock::Queue.new("a_queue") }
      before(:each) { queue.bind(exchange) }

      it "has one queue" do
        exchange.queues.should have(1).queue
      end

      it "returns the correct queue" do
        expect(exchange.queues.first).to eq(queue)
      end
    end

  end

  describe "#bound_to?" do

    let(:queue_name)  { 'a_queue' }
    let(:queue)       { BunnyMock::Queue.new(queue_name) }

    before { queue.bind(exchange) }

    it "is bound to a queue" do
      expect(exchange).to be_bound_to(queue_name)
    end

    it "is not bound to another queue" do
      expect(exchange).to_not be_bound_to('another_queue')
    end

  end

  describe "#publish" do

    let(:the_message) { 'the message' }
    let(:queue1)      { BunnyMock::Queue.new("queue1") }
    let(:queue2)      { BunnyMock::Queue.new("queue2") }

    before do
      queue1.bind(exchange)
      queue2.bind(exchange)
      exchange.publish(the_message)
    end

    it "publishes the message" do
      expect(queue1.messages).to eq([the_message])
    end

    it "publishes the snapshot message" do
      expect(queue1.messages).to eq([the_message])
    end

    it "publishes the message" do
      expect(queue2.messages).to eq([the_message])
    end

    it "publishes the snapshot message" do
      expect(queue2.messages).to eq([the_message])
    end

  end

  describe "#method_missing" do

    it "exchange.type returns the correct type" do
      expect(exchange.type).to eq(:direct)
    end

    it "exchange.durable returns true" do
      expect(exchange.durable).to be_true
    end

    it "exchange is durable" do
      exchange.should be_durable
    end

    it "exchange auto_delete is true" do
      expect(exchange.auto_delete).to be_true
    end

    it "exchange is auto_delete" do
      exchange.should be_auto_delete
    end

    it "raises NoMethodError on invalid method call" do
      expect { exchange.wtf }.to raise_error NoMethodError
    end

  end

end