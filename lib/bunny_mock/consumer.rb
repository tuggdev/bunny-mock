class BunnyMock::Consumer

  attr_accessor :message_count

  def initialize(count)
    self.message_count = count
  end

end