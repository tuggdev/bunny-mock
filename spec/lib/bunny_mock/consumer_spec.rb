require 'spec_helper'

describe BunnyMock::Consumer do

  describe '#message_count' do

    let(:msg_count) { 5 }

    subject(:consumer)  { BunnyMock::Consumer.new(msg_count) }

    it 'message count is consistent' do
      expect(consumer.message_count).to eq(msg_count)
    end

  end

end