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
    get_pages(fetch_multiple(linked_pages))
  end

  def fetch_multiple pages
    hydra = Typhoeus::Hydra.new
    requests = pages.inject({}) do |requests, page|
      request = term_show_request(page)
      hydra.queue(request)
      requests[page] = request
      requests
    end
    hydra.run
    requests
  end

  def get_pages requests
    requests.map do |name, request|
      html = request.response.body
      extractor = ContentExtractor.new(html)
      if extractor.valid?
        {name: name, extractor: extractor}
      else
        Rails.logger.warn("invalid page #{name}")
        nil
      end
    end.compact
  end

  def term_edit_request name
    Typhoeus::Request.new(
      "http://#{language}.wikipedia.org/w/index.php",
      params: { action: 'edit', title: name }
    )
  end

  def term_show_request name
    Typhoeus::Request.new "http://#{language}.wikipedia.org/wiki/#{name}", timeout: 20
  end

  def fetch_term name
    term_show_request(name).run
  end

end
