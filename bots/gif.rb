class Gif < Bot
  command     :gif
  description 'A more refined curated giphy'
  username    'gifbot'
  avatar      'http://i.imgur.com/w5yXDIe.jpg'
  help        %q(
/gif                         returns a list of possible keys
/gif KEY                     returns a gif if one is found
/gif show KEY                show the url for the given key
/gif add KEY URL             adds a new url for the given key
/gif remove KEY URL          removes the url for the given key
)

  def response
    case true
    when incoming_message.args?
      # User provided additional arguments beyond a gif key
      puts "GifBot[#{incoming_message.key}]: #{incoming_message.args}"
      send(incoming_message.key.to_sym, incoming_message.args.flatten)
    when incoming_message.key?
      # Only a key was provided
      puts "GifBot[#{incoming_message.key}]: #{incoming_message.args}"
      message = respond_with_gif
      message ? message : "No match for #{incoming_message.key}"
    else
      # List all available keys as a private response
      store.keys.join(', ')
    end
  end

  private

  def add(args)
    if args.length == 2
      store.add(*args)
      "Successfully added #{args.first}: #{args.last}"
    else
      'Usage: /gif add key url'
    end
  end

  def show(args)
    key = incoming_message.args.first
    store.list(key).join("\n")
  end

  def remove(args)
    args.length == 2 ? store.remove(*args) : 'Usage: /gif remove key url'
  end

  def respond_with_gif
    return unless image_url = store.rand(incoming_message.key)
    compose_message.tap do |message|
      message.attach_image(image_url, {
        fallback:  "#{incoming_message.user_name} posted a gif",
        author_name: incoming_message.user_name
      })
    end
  end

  def store
    @store ||= Keystore.new(:gifs)
  end
end
