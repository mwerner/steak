require 'open-uri'
require 'json'

class Frink < Bot
  command     :frink
  description "Simpsons references on demand"
  username    'frinkcjh'
  avatar      'http://i.imgur.com/EEmZJGi.png'
  help        '/frink [QUOTE]         Look up a simpsons quote in the frinkiac'

  def response
    return unless frinkiac_url = image_url
    compose_message.tap do |message|
      message.attach_image(frinkiac_url, author_name: incoming_message.user_name)
    end
  end

  private

  def image_url
    url = search_url(incoming_message.text)
    data = (JSON.parse(open(url).read.to_s) || [])[1]
    return unless data

    "https://www.frinkiac.com/img/#{data['Episode']}/#{data['Timestamp']}/medium.jpg"
  end

  def search_url(terms)
    "https://www.frinkiac.com/api/search?q=#{CGI.escape(terms)}"
  end
end
