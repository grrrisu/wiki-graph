class WikiExtractor

  attr_reader :doc

  def initialize html
    @doc = Nokogiri::HTML(html)
  end

  def extract_attributes
    attributes = { markup: extract_markup }
    if name = extract_name
      attributes[:name] = name
    end
    attributes
  end

  def extract_markup
    doc.css('textarea').text
  end

  def extract_name
    if link = doc.css('link[rel="alternate"][hreflang="x-default"]')
      link.attribute('href').value.gsub('/wiki/', '')
    end
  end

end
