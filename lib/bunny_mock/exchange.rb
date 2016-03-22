require_relative 'message'

class BunnyMock::Exchange

  attr_accessor :channel, :type, :name, :attrs, :queues, :messages

  def initialize(channel, type, name, attrs = {})
    self.channel  = channel
    self.type     = type
    self.name     = name
    self.attrs    = attrs.dup
    self.queues   = []
    self.messages = []
  end

  def publish(msg, msg_attrs = {})
    message = BunnyMock::Message.new(msg, msg_attrs)

    self.messages << message
    queues.each { |q| q.messages << message }
  end

  def bound_to?(queue_name)
    queues.any?{|q| q.name == queue_name}
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