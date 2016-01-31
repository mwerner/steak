module Slack
  class IncomingMessage < Slack::Communication
    attributes *Settings.message.incoming

    def posted_by_bot?
      self.user_name == 'slackbot'
    end
  end
end
