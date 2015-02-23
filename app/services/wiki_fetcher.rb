class WikiFetcher

  attr_reader :language, :doc

  def initialize language = 'de'
    @language = language
  end

  def get name
    html = fetch_term(name).body
    File.write(Rails.root.join('tmp', 'page.html'), html.force_encoding("UTF-8"))
    prepare_doc(html)
  end

  def prepare_doc html
    @doc = Nokogiri::HTML(html)
  end

  def extract_attributes
    {
      markup: extract_markup,
      name:   extract_name
    }
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

  def extract_markup
    doc.css('textarea').text
  end

  def extract_name
    link = doc.css('link[rel="alternate"][hreflang="x-default"]').attribute('href').value
    link.gsub('/wiki/', '')
  end

end
