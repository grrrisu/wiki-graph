class LinkBuilder

  attr_reader :term, :extractor

  def initialize term, extractor
    @term = term
    @extractor = extractor
  end

  def linked
    @linked.sort_by{|t,c| c}.reverse
  end

  def linking
    @linking.sort_by{|t,c| c}.reverse
  end

  def weight_linked_terms
    @linked = count_linked_terms
    @linking = count_linking_terms

    term.links.clear

    @linked.each do |name, linked_term_counter |
      linking_term_counter =  @linking[name] || 0
      term.links.build linked_term: Term.find_or_fetch_without_links(name, term.language),
        linked_term_counter: linked_term_counter,
        linking_term_counter: linking_term_counter,
        weight: linked_term_counter + 2 * linking_term_counter
    end
  end

  def count_linked_terms
    count_term(extractor.linked_terms) do |item|
      count_term_in_text(extractor.text, item[:name]) +
      count_term_in_text(extractor.text, item[:text])
    end
  end

  def count_linking_terms
    linked_pages = extractor.linked_terms.map {|link| link[:name] }
    responses = WikiFetcher.new(term.language).get_linked_pages(linked_pages)

    count_term(responses) do |item|
      count_term_in_text(item[:extractor].text, term.name) +
      count_term_as_link(item[:extractor].linked_terms, term.name)
    end
  end

  def count_term_in_text text, term
    text.scan(/\b#{term}\b/).size
  end

  def count_term_as_link links, name
    links.find {|link| link[0]  == name} ? 3 : 0
  end

  # list [ {name, text / extractor } ]
  def count_term list
    list.inject({}) do |hash, term|
      hash[term[:name]] ||= 0
      hash[term[:name]] += yield(term)
      hash
    end
  end

end