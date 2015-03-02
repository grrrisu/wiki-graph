class TermBuilder

  attr_reader :name, :language, :extractor, :linked, :linking, :weight

  def initialize name, language = 'de'
    @name = name
    @language = language
    html = WikiFetcher.new(language).get name
    @extractor = ContentExtractor.new(html)
  end

  def create!
    Term.create! name: extractor.name || name, content: extractor.content, language: language
  end

  def weight_linked_terms
    @linked = count_linked_terms
    @linking = count_linking_terms

    @weight = {}
    @linked.each do |term|
      @weight[term[0]] = [] << term[1]
    end
    @linking.each do |term|
      @weight[term[0]] << term[1]
    end
    @weight.each do |term, counters|
      @weight[term] << counters[0] + 2 * counters[1]
    end
    @weight.sort_by {|term, counters| counters.last }.reverse
  end

  def count_linked_terms
    count_term(extractor.linked_terms) do |item|
      count_term_in_text(extractor.text, item[0]) +
      count_term_in_text(extractor.text, item[1])
    end
  end

  def count_linking_terms
    linked_pages = extractor.linked_terms.map {|term| term[0] }
    responses = WikiFetcher.new.get_linked_pages(linked_pages)

    count_term(responses) do |item|
      count_term_in_text(item[1].text, name) +
      count_term_as_link(item[1].linked_terms, name)
    end
  end

  def count_term_in_text text, term
    text.scan(/\b#{term}\b/).size
  end

  def count_term_as_link links, term
    links.find {|link| link[0]  == name} ? 3 : 0
  end

  private

  # list [ [page, name] ]
  def count_term list
    list.inject({}) do |hash, term|
      hash[term[0]] ||= 0
      hash[term[0]] += yield(term)
      hash
    end.sort_by do |key, value|
      value
    end.reverse
  end

end
