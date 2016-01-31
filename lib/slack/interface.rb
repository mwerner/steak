module Slack
  class Interface
    attr_reader :channel, :observers

    def initialize(channel, path)
      @channel = Slack::Channel.new(self, channel, path)
      @observers = []
    end

    def receive(*args, params)
      puts args.inspect
      puts params.inspect
      message = Slack::IncomingMessage.new(params)
      notify_message_observers(message)
      "Hello World"
    end

    def register_bot(name)
      bot = name.split('_').collect(&:capitalize).join
      return unless Object.const_defined?(bot)

      puts "Registering bot: #{bot}"
      @observers << Object.const_get(bot)
    end

    def notify_message_observers(message)
      observers.each { |observer| observer.call(channel, message) }
    end
  end
end
