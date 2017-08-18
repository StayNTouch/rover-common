class SNT::Core::Services::InvalidException < StandardError
  def initialize(message)
    super(message)
  end
end
