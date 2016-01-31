module Slack
  class MessageAttachment < Slack::Communication
    attributes *Settings.message.attachment.attributes, :fields

    def initialize(attributes = {})
      super
      self.fields = []
    end
  end
end
