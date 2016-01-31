module Slack
  class Interface
    attr_reader :channel, :bots

    def initialize(channel, path)
      @channel = Slack::Channel.new(self, channel, path)
      @bots = []
    end

    def receive(*args, params)
      puts "Processing: #{args} #{params}"
      notify_message_bots Slack::IncomingMessage.new(params)
      "OK"
    end

    def register_bot(name)
      bot = name.split('_').collect(&:capitalize).join
      return unless Object.const_defined?(bot)
      @bots << Object.const_get(bot)
    end

    def notify_message_bots(message)
      bots.each do |bot|
        response = bot.call(channel, message)
        next if response.nil?

        channel.post response
      end
    end
  end
end
