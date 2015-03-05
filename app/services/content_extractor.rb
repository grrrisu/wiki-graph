class ContentExtractor

  attr_reader :doc

  IGNORE_LINKS = %w{Spezial:ISBN-Suche Datei: File: Wikipedia:Kategorien Kategorie:Wikipedia: Kategorie:!Wikipedia Hilfe: (Begriffsklärung)}

  def initialize html
    @doc = Nokogiri::HTML(html)
  end

  def valid?
    content
  end

  def content
    @content ||= doc.css('#mw-content-text').first
  end

  def text
    content.text
  end

  def html
    content.inner_html
  end

  def linked_terms
    @linked_terms ||= internal_links(content)
  end

  def category_box
    doc.css('#catlinks')
  end

  def categories
    @categories ||= internal_links(category_box)
  end

  def name
    if link = doc.css('link[rel="alternate"][hreflang="x-default"]')
      link.attribute('href').value.gsub('/wiki/', '')
    end
  end

  private

  def internal_links element
    element.css("a[href^='/wiki/']").map do |link|
      name = linked_page(link)
      if ignore_link(name) && link.text.present?
        { name: name, text: link.text }
      end
    end.compact
  end

  def linked_page link
    URI.unescape(link.attribute('href').value.gsub('/wiki/', ''))
  end

  def ignore_link link
    IGNORE_LINKS.none? {|ignore| link.include?(ignore) }
  end

end
