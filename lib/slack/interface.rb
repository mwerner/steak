module Slack
  class Interface
    attr_reader :channel, :bots

    def initialize(channel, path)
      @channel = Slack::Channel.new(self, channel, path)
      @bots = []
    end

    def receive(*args, params)
      puts "Processing: #{args} #{params}"

      action = 
      message = Slack::IncomingMessage.new(params)

      notify_message_bots args.first, message
      "OK"
    end

    def register_bot(name)
      bot = name.split('_').collect(&:capitalize).join
      return unless Object.const_defined?(bot)
      @bots << Object.const_get(bot)
    end

    private

    def notify_message_bots(action, message)
      bots.each do |bot|
        response = bot.call(action, channel, message)
        next if response.nil?

        channel.post response
      end
    end
  end
end
