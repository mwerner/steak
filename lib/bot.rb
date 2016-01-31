class Bot
  attr_reader :channel, :incoming_message, :matches

  def initialize(channel, incoming_message)
    @channel = channel
    @incoming_message = incoming_message
    if self.class.observer?
      @matches = incoming_message.text.to_s.scan(self.class.pattern).flatten
    end
  end

  def self.call(channel, incoming_message)
    return true if (!respond_to_bots? && incoming_message.posted_by_bot?)

    handler = new(channel, incoming_message)
    return if observer? && handler.matches.empty?

    handler.response
  end

  def call
    raise NotImplementedError, "#call must be implemented by subclasses"
  end

  def compose_message
    Slack::OutgoingMessage.new({
      channel:  "##{incoming_message.channel_name}",
      username: self.class.instance_variable_get(:@username),
      icon_url: self.class.instance_variable_get(:@avatar)
    })
  end

  def self.pattern
    @pattern
  end

  protected

  def self.username(name)
    @username = name
  end

  def self.avatar(url)
    @avatar = url
  end

  def self.observes(pattern, options = {})
    @pattern = pattern
  end

  def self.observer?
    !@pattern.nil?
  end

  private

  def self.respond_to_bots?
    false
  end
end
