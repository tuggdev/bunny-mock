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

  def self.queue(name, opts = {})
    queues[name] ||= BunnyMock::Queue.new(name, opts)
  end

  def self.exchange(name, opts = {})
    channel = opts.delete(:channel) || BunnyMock::Channel.new
    type = opts.delete(:type) || :direct

    exchanges[name] ||= BunnyMock::Exchange.new(channel, type, name, opts)
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