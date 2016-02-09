module ImageControl
  def attached_image(options = {})
    feedback = options[:feedback] || 'No Image Found'
    return feedback unless attachment_url = image_url
    compose_message(options[:message] || {}).tap do |message|
      message.attach_image(attachment_url, {
        fallback: "#{incoming_message.user_name} posted an image",
        author_name: incoming_message.user_name
      }.merge(options[:attachment] || {}))
    end
  end

  def controls_images?
    true
  end
end
