class Finance < Bot
  observes    /\$([A-Z]{1,5})/
  description 'Provides a chart for stock tickers prefixed with $'
  username    'greedcjh'
  avatar      'http://imgur.com/MeYf2Ee.jpg'

  def response
    compose_message.tap do |message|
      @symbol = matches.shift
      message.attach_image(image_url, {
        title: chart_title(@symbol, matches.map{|sym| "$#{sym}" }),
        title_link: google_finance_link(@symbol)
      })
    end
  end

  private

  def chart_title(symbol, symbols = [])
    title = "$#{symbol}"
    if symbols.any?
     title += "vs #{symbols.join(', ')}"
    end

    title
  end

  def image_url
    "http://chart.finance.yahoo.com/z?#{chart_attributes(@symbol, matches)}"
  end

  def google_finance_link(symbol)
    "https://www.google.com/finance?q=#{symbol}"
  end

  def chart_attributes(symbol, comparisons = [])
    "s=#{symbol}&t=7d&q=l&l=on&z=s&p=m50,v&c=#{comparisons.join(',')}"
  end
end
