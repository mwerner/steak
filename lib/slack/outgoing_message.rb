module Slack
  class OutgoingMessage < Slack::Communication
    attributes *Settings.message.outgoing.attributes, :attachments

    def initialize(attributes = {})
      super
      self.attachments = []
    end
  end
end
