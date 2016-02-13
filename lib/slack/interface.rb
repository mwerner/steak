module Slack
  class Interface
    attr_reader :channel, :bots

    def initialize(channel, path)
      @channel = Slack::Channel.new(self, channel, path)
      @bots = []
      flush_buffer
    end

    def receive(*args, params)
      message = Slack::IncomingMessage.new(params)
      notify_message_bots args.first, message
      flush_buffer
    end

    def register_bot(name)
      bot = name.split('_').collect(&:capitalize).join
      return unless Object.const_defined?(bot)
      @bots << Object.const_get(bot)
    end

    private

    def notify_message_bots(action, message)
      bots.each do |bot|
        # puts "Notifying: #{bot}"
        response = bot.call(action, channel, message)
        next if response.nil?

        if response.is_a?(Slack::OutgoingMessage)
          content = response.attachments.any? ? "attachments" : response.text
          puts "Response: @#{response.username} posts #{content} to #{response.channel}\n"

          channel.post response
        elsif response
          puts "Response: Feedback - #{response}\n"
          @output << response
        end
      end
    end

    def flush_buffer
      content = (@output || []).join("\n")
      @output = [] # Need to clear this between messages
      content
    end
  end
end
