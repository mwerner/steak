module ScraperControl

  def self.included(base)
    puts 'included'
    base.class_eval do
      declarable :selector
    end
  end

  def document
    @document ||= Nokogiri::HTML(open(document_url))
  end

  def scraped_content
    document.css(self.class.selector)
  end
end
