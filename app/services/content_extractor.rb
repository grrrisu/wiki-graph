class ContentExtractor

  attr_reader :doc

  def initialize html
    @doc = Nokogiri::HTML(html)
  end

  def content
    doc.css('#mw-content-text').first
  end

  def text
    content.text
  end

  def html
    content.inner_html
  end

  def linked_terms
    @linked_terms ||= content.css("a[href^='/wiki/']").map do |link|
      [linked_page(link), link.text] unless link.text.empty?
    end.compact
  end

  def categories
    doc.css('#catlinks')
  end

  def name
    if link = doc.css('link[rel="alternate"][hreflang="x-default"]')
      link.attribute('href').value.gsub('/wiki/', '')
    end
  end

  private

  def linked_page link
    URI.unescape(link.attribute('href').value.gsub('/wiki/', ''))
  end

end
