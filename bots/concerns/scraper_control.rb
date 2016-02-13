module ScraperControl
  def self.included(base)
    base.class_eval do
      declarable :selector, :document_url
    end
  end

  def document
    @document ||= Nokogiri::HTML(open(self.class.document_url))
  end

  def scraped_content
    document.css(self.class.selector)
  end
end
