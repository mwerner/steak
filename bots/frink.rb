class Frink < Bot
  command     :frink
  username    'frinkcjh'
  description "Simpsons references on demand"
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
    query = CGI.escape(incoming_message.text)
    api_url = "https://www.frinkiac.com/api/search?q=#{query}"
    return unless data = request(api_url).first

    "https://www.frinkiac.com/img/#{data['Episode']}/#{data['Timestamp']}/medium.jpg"
  end

  def request(url)
    JSON.parse(open(url).read)
  end
end
