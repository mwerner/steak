module Slack
  class IncomingMessage
    ATTRIBUTES = Settings.message.incoming.attributes.map(&:to_sym).freeze
    attr_accessor *ATTRIBUTES

    def initialize(attributes = {})
      attributes.each{|k, v| send("#{k}=", v) }
    end

    def posted_by_bot?
      self.user_name == 'slackbot'
    end
  end
end
