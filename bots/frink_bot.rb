class FrinkBot < Bot
  include ImageControl
  command     :frink
  username    'frinkcjh'
  description "Simpsons references on demand"
  avatar      'http://i.imgur.com/EEmZJGi.png'
  help        '/frink [QUOTE]         Look up a simpsons quote in the frinkiac'

  def response
    return unless data = request("api/search?q=#{CGI.escape(incoming_message.text)}").first
    @number, @timestamp = episode['Episode'], episode['Timestamp']

    attached_image({
      attachment: { text: captions.join("\n\n") }
    })
  end

  private

  def image_url
    "https://www.frinkiac.com/img/#{@number}/#{@timestamp}/medium.jpg"
  end

  def captions
    captions = request("api/caption?e=#{@number}&t=#{@timestamp}")
    captions['Subtitles'].map{|s| s['Content'] }
  end

  def request(path)
    JSON.parse(open("https://www.frinkiac.com/#{path}").read)
  end
end
