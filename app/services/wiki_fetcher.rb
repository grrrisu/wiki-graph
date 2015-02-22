class WikiFetcher

  attr_reader :language

  def initialize language = 'de'
    @language = language
  end

  def get name
    html = fetch_term(name).body
    text = filter_text(html)
    parse(text)
  end

  def term_request name
    Typhoeus::Request.new(
      "http://#{language}.wikipedia.org/w/index.php",
      params: { action: 'edit', title: name }
    )
  end

  def fetch_term name
    term_request(name).run
  end

  def filter_text html
    doc = Nokogiri::HTML(html)
    doc.css('textarea').text
  end

  def parse text
    @parser = WikiCloth::Parser.new(data: text)
    @parser.to_html
  end

  def linked_terms
    @parser.internal_links
  end

end
