require 'lib/declarative_class'

class Bot < DeclarativeClass
  attr_reader :action, :channel, :incoming_message, :matches

  declarable :description, :username, :avatar, :pattern, :command, :screenshot_url, :help

  def initialize(action, channel, incoming_message)
    @action = action
    @channel = channel
    @incoming_message = incoming_message
    @matches = []
    @matches = incoming_message.text.to_s.scan(self.class.pattern).flatten if observer?
  end

  def self.all
    Dir["bots/*.rb"].map do |bot|
      botname = File.basename(bot, '.rb').camelize
      next unless Object.const_defined?(botname)

      Object.const_get(botname)
    end
  end

  def self.call(action, channel, incoming_message)
    return if (!respond_to_bots? && incoming_message.posted_by_bot?)

    handler = new(action, channel, incoming_message)
    return unless handler.valid_handler?

    puts "#{handler.class.name}[#{incoming_message.key}]: #{incoming_message.args}"
    handler.response
  end

  def response
    return help           if invoked? && incoming_message.help?
    return send_command   if controls_commands?
    return attached_image if controls_images?

    raise NotImplementedError, "#response must be implemented by subclasses"
  end

  def compose_message(options = {})
    Slack::OutgoingMessage.new({
      channel:  "##{incoming_message.channel_name}",
      username: self.class.username || 'CjhBot',
      icon_url: self.class.avatar || 'http://i.imgur.com/w5yXDIe.jpg',
      link_names: 1
    }.merge(options))
  end

  def valid_handler?
    return true if observer? && matches.any?
    return true if commandline? && invoked?
    false
  end

  def self.help(value = nil)
    if value
      set_help(value)
      return
    end

    root = Sinatra::Application.settings.root
    path = File.join(root, 'docs', "#{name.downcase}.txt")
    return @help unless File.exist?(path)

    "#{@help}#{File.read(path)}"
  end

  def help
    begin
      [
        "#{self.class.name}Bot",
        "#{self.class.description}\n",
        self.class.help,
        "/#{self.class.command} help                    returns this list"
      ].join("\n")
    rescue NameError
      "No help defined for #{self.class.name}Bot"
    end
  end

  def invoked?
    return false unless commandline?
    action.to_s.to_sym == self.class.command.to_sym
  end

  def controls_commands?
    false
  end

  def controls_images?
    false
  end

  def self.test_instance(options = {})
    channel = options[:channel] || Application.connection
    message = options[:message] || Slack::IncomingMessage.new(text: options[:text])
    new(command || :message, channel, message)
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

  private

  def self.respond_to_bots?
    false
  end
end
