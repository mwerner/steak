require 'lib/declarative_class'

class Bot < DeclarativeClass
  attr_reader :action, :channel, :incoming_message, :matches

  declarable :description, :username, :avatar, :pattern, :command

  def initialize(action, channel, incoming_message)
    @action = action
    @channel = channel
    @incoming_message = incoming_message
    @matches = observer? ? incoming_message.text.to_s.scan(self.class.pattern).flatten : []
  end

  def self.call(action, channel, incoming_message)
    return if (!respond_to_bots? && incoming_message.posted_by_bot?)

    new(action, channel, incoming_message).respond
  end

  def respond
    return if observer?    && matches.empty?
    return if commandline? && !handles_command?(action)

    response
  end

  def response
    raise NotImplementedError, "#response must be implemented by subclasses"
  end

  def compose_message(options = {})
    Slack::OutgoingMessage.new({
      channel:  "##{incoming_message.channel_name}",
      username: self.class.username,
      icon_url: self.class.avatar,
      link_names: 1
    }.merge(options))
  end

  protected

  def self.observes(regex)
    pattern(regex)
  end

  def self.observer?
    !@pattern.nil?
  end

  def observer?
    self.class.observer?
  end

  def self.commandline?
    !@command.nil?
  end

  def commandline?
    self.class.commandline?
  end

  def handles_command?(command)
    return false unless commandline?
    command.to_s.to_sym == self.class.command.to_sym
  end

  private

  def self.respond_to_bots?
    false
  end
end
