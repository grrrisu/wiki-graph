class WikiFetcher

  attr_reader :language

  def initialize language = 'de'
    @language = language
  end

  def get name
    html = fetch_term(name).body
    File.write(Rails.root.join('tmp', 'example_raw.html'), html.force_encoding("UTF-8"))
    text = filter_text(html)
    WikiParser.parse(name, text)
  end

  def get_linked_pages linked_pages
    hydra = Typhoeus::Hydra.new
    requests = linked_pages.inject({}) do |requests, page|
      request = term_request(page)
      hydra.queue(request)
      requests[page] = request
      requests
    end
    hydra.run
    reponses = requests.each { |page, request|
      html = request.response.body
      markup = filter_text(html)
      requests[page] = markup
    }
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

end
