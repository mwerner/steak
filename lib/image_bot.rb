require 'lib/bot'

class ImageBot < Bot
  def response
    return unless attachment_url = image_url

    compose_message.tap do |message|
      message.attach_image(attachment_url, author_name: incoming_message.user_name)
    end
  end
end
