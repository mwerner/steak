class Finance < Bot
  CHART_HOST = 'http://chart.finance.yahoo.com'

  description 'Provides a chart for stock tickers prefixed with $'
  username 'greedcjh'
  avatar   'http://imgur.com/MeYf2Ee.jpg'
  observes /\$([A-Z]{1,5})/

  def response
    compose_message.tap do |message|
      symbol = matches.shift
      symbol_keys = matches.map{|sym| "$#{sym}" }
      message.attachments << Slack::MessageAttachment.new({
        title:      "$#{symbol} vs #{symbol_keys.join(', ')}",
        title_link: google_finance_link(symbol),
        image_url:  "#{CHART_HOST}/z?#{chart_attributes(symbol, matches)}"
      })
    end
  end

  private

  def google_finance_link(symbol)
    "https://www.google.com/finance?q=#{symbol}"
  end

  def chart_attributes(symbol, comparisons = [])
    "s=#{symbol}&t=7d&q=l&l=on&z=s&p=m50,v&c=#{comparisons.join(',')}"
  end
end
