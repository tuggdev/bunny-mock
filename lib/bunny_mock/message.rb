class BunnyMock::Message < Delegator

  attr_accessor :metadata

  def initialize(payload, metadata = {})
    super(payload)

    self.metadata  = metadata
    @delegate_sd_obj = payload
  end

  def __getobj__
    @delegate_sd_obj
  end

  def __setobj__(obj)
    @delegate_sd_obj = obj
  end

end