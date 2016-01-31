class Application
  @connection = nil

  def self.connection
    @connection
  end

  def self.connection=(value)
    @connection = value
  end
end
