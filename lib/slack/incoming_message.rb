module Slack
  class IncomingMessage < Slack::Communication
    attributes *Settings.message.incoming

    # This is when a slash command had only one argument
    def key
      text.to_s.match(/([\w|-]*)(.*)/)[1]
    end

    def args
      text.to_s.match(/([\w|-]*)(.*)/).to_a.last.to_s.split(' ').flatten
    end

    def key?
      !key.nil? && key != ''
    end

    def args?
      !args.empty?
    end

    def key_with_args?
      key && !args.empty?
    end

    def posted_by_bot?
      self.user_name == 'slackbot'
    end
  end
end
