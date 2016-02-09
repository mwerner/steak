class Finance < Bot
  include ImageControl
  observes    /\$([A-Z]{1,5})/
  description 'Provides a chart for stock tickers prefixed with $'
  username    'greedcjh'
  avatar      'http://imgur.com/MeYf2Ee.jpg'

  def response
    @symbol = matches.shift
    attached_image(attachment: {
      title: chart_title,
      title_link: google_finance_link
    })
  end

  private

  def chart_title
    title = "$#{@symbol}"
    if matches.any?
     title += "vs #{matches.map{|sym| "$#{sym}" }.join(', ')}"
    end

    title
  end

  def image_url
    comparisons = matches.join(',')
    "http://chart.finance.yahoo.com/z?#{{
      s: @symbol, t: '7d', q: 'l', l: 'on',
      z: 's', p: 'm50,v', c: comparisons
    }.to_params}"
  end

  def google_finance_link
    "https://www.google.com/finance?q=#{@symbol}"
  end
end
