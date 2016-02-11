class FrinkBot < Bot
  include ImageControl
  command     :frink
  username    'frinkcjh'
  description "Simpsons references on demand"
  avatar      'http://i.imgur.com/EEmZJGi.png'
  help        '/frink [QUOTE]         Look up a simpsons quote in the frinkiac'

  private

  def image_url
    query = CGI.escape(incoming_message.text)
    api_url = "https://www.frinkiac.com/api/search?q=#{query}"
    return unless data = JSON.parse(open(api_url).read).first

    "https://www.frinkiac.com/img/#{data['Episode']}/#{data['Timestamp']}/medium.jpg"
  end
end
