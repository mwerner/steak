module Slack
  class OutgoingMessage < Slack::Communication
    attributes *Settings.message.outgoing.attributes, :attachments

    def initialize(attributes = {})
      super
      self.attachments = []
    end

    def attach(attrs)
      self.attachments << Slack::MessageAttachment.new(attrs)
    end

    def attach_image(url, attrs = {})
      self.attach({
        fallback:  text,
        author_name: username,
        image_url: url
      }.merge(attrs))
    end
  end
end
