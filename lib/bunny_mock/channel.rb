require_relative 'exchange'
require_relative 'queue'

class BunnyMock::Channel

  def initialize
    @queues    = {}
    @exchanges = {}
    @default_exchange = self.direct('', { no_declare: true })
  end

  def prefetch(n); end
  def acknowledge(tag); end

  def queue(name, opts = {})
    @queues[name] ||= BunnyMock::Bunny.queue(name, opts)
  end

  def direct(name, opts = {})
    @exchanges[name] ||= BunnyMock::Bunny.exchange(name, opts.merge(channel: self, type: :direct))
  end

  def fanout(name, opts = {})
    @exchanges[name] ||= BunnyMock::Bunny.exchange(name, opts.merge(channel: self, type: :fanout))
  end

  def exchange(name, opts = {})
    @exchanges[name] ||= BunnyMock::Bunny.exchange(name, opts.merge(channel: self))
  end

end