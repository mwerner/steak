class GifBot < Bot
  include ImageControl
  include CommandControl

  command     :gif
  username    'gifbot'
  description 'A more refined curated giphy'
  avatar      'http://i.imgur.com/w5yXDIe.jpg'

  # Command Bots simplify the slack command interface:
  # Examples:

  # /gif
  # Executes: `#bare`

  # /gif hotline
  # Executes: `#default('hotline')`

  # /gif add hotline http://i.imgur.com/hyE9zfo.gif
  # Executes: `#add(['hotline', 'http://i.imgur.com/hyE9zfo.gif'])`

  # /gif remove hotline http://i.imgur.com/7ua6K8P.gif
  # Executes: `#remove(['hotline', 'http://i.imgur.com/hyE9zfo.gif'])`
  def bare
    store.keys.join(', ')
  end

  def default(args)
    attached_image(feedback: "No match for #{incoming_message.key}")
  end

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
    store.list(key).join("\n  ")
  end

  def remove(args)
    if args.length == 2
      store.remove(*args)
      "Successfully removed #{args.first}: #{args.last}"
    else
      'Usage: /gif remove key url'
    end
  end

  private

  def image_url
    store.rand(incoming_message.key)
  end

  def store
    @store ||= Keystore.new(:gifs)
  end
end
