require_relative 'channel'
require_relative 'exchange'

class BunnyMock::Bunny

  def start
    :connected
  end

  def stop
    nil
  end

  def create_channel
    BunnyMock::Channel.new
  end

  def direct(name, *args)
    BunnyMock::Exchange.new(name, *args)
  end

  def queue_exists?(name)
    self.class.queues.has_key?(name)
  end

  def exchange_exists?(name)
    self.class.exchanges.has_key?(name)
  end

  def self.queue(name, attrs = {})
    queues[name] ||= BunnyMock::Queue.new(name, attrs)
  end

  def self.exchange(channel, type, name, attrs = {})
    queues[name] ||= BunnyMock::Exchange.new(channel, type, name, attrs)
  end

  def self.queues
    @queues ||= {}
  end

  def self.exchanges
    @exchanges ||= {}
  end

  def self.reset!
    @queues = nil
    @exchanges = nil
  end

end