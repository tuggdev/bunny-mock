require 'spec_helper'

describe BunnyMock::Bunny do

  subject(:bunny) { BunnyMock::Bunny.new }

  describe "#start" do
    it "connects" do
      expect(bunny.start).to eq(:connected)
    end
  end

  describe "#stop" do
    it "returns nil" do
      expect(bunny.stop).to eq(nil)
    end
  end

  describe "#create_channel" do
    it "returns a new channel" do
      expect(bunny.create_channel).to be_a(BunnyMock::Channel)
    end
  end

  describe '.queue' do

    let(:queue_name) { 'my_queue' }

    it "is a BunnyMock::Queue" do
      expect(BunnyMock::Bunny.queue(queue_name)).to be_a(BunnyMock::Queue)
    end

    it 'name is consistent' do
      expect(BunnyMock::Bunny.queue(queue_name).name).to eq(queue_name)
    end

  end

end