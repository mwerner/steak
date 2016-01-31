class Finance < Bot
  username 'greedcjh'
  avatar   'http://imgur.com/MeYf2Ee.jpg'
  observes /\$([A-Z]{1,5})/, scan: true

  def response
    compose_message.tap do |message|
      symbol = matches.shift
      symbol_keys = matches.map{|sym| "$#{sym}" }
      message.attachments << Slack::MessageAttachment.new({
        title:      "$#{symbol} vs #{symbol_keys.join(', ')}",
        title_link: "https://www.google.com/finance?q=#{symbol}",
        image_url:  "http://chart.finance.yahoo.com/z?s=#{symbol}&t=7d&q=l&l=on&z=s&p=m50,v&c=#{matches.join(',')}"
      })
    end
  end
end
