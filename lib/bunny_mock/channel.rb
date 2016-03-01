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

  def queue(name, attrs = {})
    @queues[name] ||= BunnyMock::Bunny.queue(name, attrs)
  end

  def direct(name, attrs = {})
    BunnyMock::Exchange.new(self, :direct, name, attrs).tap { |e| @exchanges[name] = e }
  end

  def fanout(name, attrs = {})
    BunnyMock::Exchange.new(self, :fanout, name, attrs).tap { |e| @exchanges[name] = e }
  end

end