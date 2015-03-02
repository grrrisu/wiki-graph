class WikiFetcher

  attr_reader :language

  def initialize language = 'de'
    @language = language
  end

  def get name
    fetch_term(name).body.force_encoding("UTF-8").tap do |html|
      File.write(Rails.root.join('tmp', 'page.html'), html)
    end
  end

  def get_linked_pages linked_pages
    hydra = Typhoeus::Hydra.new
    requests = linked_pages.inject({}) do |requests, page|
      request = term_show_request(page)
      hydra.queue(request)
      requests[page] = request
      requests
    end
    hydra.run
    reponses = requests.each { |page, request|
      html = request.response.body
      requests[page] = ContentExtractor.new(html)
    }
  end

  def term_edit_request name
    Typhoeus::Request.new(
      "http://#{language}.wikipedia.org/w/index.php",
      params: { action: 'edit', title: name }
    )
  end

  def term_show_request name
    Typhoeus::Request.new "http://#{language}.wikipedia.org/wiki/#{name}"
  end

  def fetch_term name
    term_show_request(name).run
  end

end
