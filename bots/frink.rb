require 'open-uri'
require 'json'

class Frink < Bot
  description "Simpsons references on demand"
  username    'frinkcjh'
  avatar      'http://i.imgur.com/EEmZJGi.png'
  command     :frink

  HELP = "/frink [TERM] [TERM]         Look up a simpsons moment in the frinkiac"

  def response
    return unless frinkiac_url = image_url
    compose_message.tap do |message|
      message.attachments << Slack::MessageAttachment.new({
        fallback:  incoming_message.text,
        author_name: incoming_message.user_name,
        image_url: frinkiac_url
      })
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
