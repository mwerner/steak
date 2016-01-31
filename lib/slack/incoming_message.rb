module Slack
  class IncomingMessage < Slack::Communication
    attributes Settings.message.incoming.attributes.map(&:to_sym).freeze

    def posted_by_bot?
      self.user_name == 'slackbot'
    end
  end
end
