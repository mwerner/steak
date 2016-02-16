module Slack
  class IncomingMessage < Slack::Communication
    attributes *Settings.message.incoming

    def arguments(delimiter = "\s")
      @arguments ||= text.scan(/([\w|-]*)#{delimiter}{0,1}/).flatten.reject(&:blank?)
    end

    # This is when a slash command had only one argument
    def key
      arguments[0]
    end

    def args_string
      text.to_s.match(/([\w|-]*)(.*)/).to_a.last.to_s.lstrip
    end

    def args
      args_string.split(' ').flatten
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

    def help?
      key == 'help'
    end

    def posted_by_bot?
      self.user_name == 'slackbot'
    end
  end
end
