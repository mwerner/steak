module Slack
  class Interface
    attr_reader :channel, :bots

    def initialize(channel, path)
      @channel = Slack::Channel.new(self, channel, path)
      @bots = []
      @output = []
    end

    def receive(*args, params)
      puts "Processing: #{args} #{params}"
      message = Slack::IncomingMessage.new(params)

      notify_message_bots args.first, message
      @output.join("\n")
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

        puts "[#{bot.name}] Received: #{response.inspect}"
        if response.is_a?(Slack::OutgoingMessage)
          channel.post response
        elsif response
          @output << response
        end
      end
    end
  end
end
