require_relative 'consumer'

class BunnyMock::Queue

  attr_accessor :name, :attrs, :messages, :delivery_count

  def initialize(name, attrs = {})
    self.name           = name
    self.attrs          = attrs.dup
    self.messages       = []
    self.delivery_count = 0
  end

  def bind(exchange, *args)
    exchange.queues << self
  end

  # Note that this doesn't block waiting for messages like the real world.
  def subscribe(*args, &block)
    while message = messages.shift
      self.delivery_count += 1
      yield({:payload => message})
    end
  end

  def publish(msg, msg_attrs = {})
    self.messages << msg
  end

  def default_consumer
    BunnyMock::Consumer.new(self.delivery_count)
  end

  def method_missing(method, *args)
    method_name  = method.to_s
    is_predicate = false
    if method_name =~ /^(.*)\?$/
      key           = $1.to_sym
      is_predicate = true
    else
      key = method.to_sym
    end

    if attrs.has_key? key
      value = attrs[key]
      is_predicate ? !!value : value
    else
      super
    end
  end

end