require 'nokogiri'

class CultureBot < Bot
  command         :culture
  description     "Culture Yo'Self"
  username        'culturecjh'
  avatar          'http://i.imgur.com/w5yXDIe.jpg'
  screenshot_url  'http://i.imgur.com/Owi9mSi.png'
  help            '/culture           Get cultured with a quote by David Foster Wallace'

  ROOT_URL = "http://www.goodreads.com/author/quotes/4339.David_Foster_Wallace"

  def response
    compose_message(text: culture_bomb)
  end

  private

  def culture_bomb
    # Get the main page
    root = Nokogiri::HTML(open(ROOT_URL))

    # Total pages
    total_pages = root.xpath("//a[contains(@href, 'page=')]").map(&:text).map(&:to_i).max

    # Only interested in the first half of pages
    max_page = total_pages / 2

    # Grab a random page
    doc = Nokogiri::HTML(open("#{ROOT_URL}?page=#{max_page + 1}"))

    # Grab a random quote
    doc.css('.quoteText').collect{|q| q.children.first.text}.map(&:strip).sample
  end
end
