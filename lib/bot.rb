class Bot
  attr_reader :channel, :incoming_message, :matches

  def initialize(channel, incoming_message)
    @channel = channel
    @incoming_message = incoming_message
    if self.class.observer?
      @matches = incoming_message.text.to_s.scan(self.class.pattern).flatten
    end
  end

  def self.call(action, channel, incoming_message)
    return true if (!respond_to_bots? && incoming_message.posted_by_bot?)

    handler = new(channel, incoming_message)
    return if observer?     && handler.matches.empty?
    puts "not an observer: #{commandline?} && #{action}"
    return if commandline? && !handler.handles?(action)

    handler.response
  end

  def call
    raise NotImplementedError, "#call must be implemented by subclasses"
  end

  def compose_message(options = {})
    Slack::OutgoingMessage.new({
      channel:  "##{incoming_message.channel_name}",
      username: self.class.instance_variable_get(:@username),
      icon_url: self.class.instance_variable_get(:@avatar)
    }.merge(options))
  end

  def self.pattern
    @pattern
  end

  def self.action_name
    @action_name
  end

  def handles?(action)
    return false unless self.class.action_name
    action.to_sym == self.class.action_name.to_sym
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

  def self.action(action_name, options = {})
    @action_name = action_name
  end

  def self.observer?
    !@pattern.nil?
  end

  def self.commandline?
    !@action_name.nil?
  end

  private

  def self.respond_to_bots?
    false
  end
end
