class Gif < Bot
  username 'gifbot'
  avatar   'http://imgur.com/MeYf2Ee.jpg'
  action   :gif

  # If the message only includes a key, post the gif
  # If other arguments are provided, map those to the private messages on this bot

  def response
    case true
    when incoming_message.args?
      puts "GifBot[#{incoming_message.command}]: #{incoming_message.args}"
      send(incoming_message.command.to_sym, incoming_message.args)
    when incoming_message.key?
      puts "GifBot[#{incoming_message.command}]: #{incoming_message.args}"
      message = respond_with_gif
      message ? message : "No match for #{incoming_message.key}"
    else
      store.keys
    end
  end

  private

  def add(args)
    store.add(*args)
  end

  def show(*args)
    store.list(incoming_message.key)
  end

  def respond_with_gif
    return unless image_url = store.rand(incoming_message.key)
    compose_message.tap do |message|
      message.attachments << Slack::MessageAttachment.new({
        # text: incoming_message.text, # Uncomment if you prefer the key to be shown
        fallback:  "#{incoming_message.user_name} posted a gif",
        author_name: incoming_message.user_name,
        image_url: image_url
      })
    end
  end

  def store
    @store ||= Keystore.new(:gifs)
  end
end
