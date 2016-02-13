class CultureBot < Bot
  include ScraperControl

  command         :culture
  description     "Culture Yo'Self"
  username        'culturecjh'
  avatar          'http://i.imgur.com/w5yXDIe.jpg'
  screenshot_url  'http://i.imgur.com/Owi9mSi.png'
  selector        '.quoteText'
  help            '/culture           Get cultured with a quote by David Foster Wallace'

  def response
    culture = scraped_content.collect{|q| q.children.first.text}.map(&:strip).sample
    compose_message(text: culture)
  end

  private

  def self.document_url
    url = 'http://www.goodreads.com/author/quotes/4339.David_Foster_Wallace'
    paginated_links = Nokogiri::HTML(open(url)).xpath("//a[contains(@href, 'page=')]")
    total_pages = paginated_links.map(&:text).map(&:to_i).max
    "#{url}?page=#{(total_pages / 2) + 1}"
  end
end
