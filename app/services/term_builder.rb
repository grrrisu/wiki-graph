# creates or updates a term and all associtations
class TermBuilder

  attr_reader :term

  def initialize name, language = 'de'
    @term = Term.find_or_build(name, language)
  end

  def fetcher
    @fetcher ||= WikiFetcher.new term.language
  end

  def extractor
    @extractor ||= ContentExtractor.new fetcher.get(term.name)
  end

  def fetch
    set_name
    weight_linked_terms
    term
  end

  def fetch!
    fetch.save!
  end

  def set_name
    name = extractor.name
    term.name =  name if name.present?
  end

  def linked
    @linked.sort_by{|t,c| c}.reverse
  end

  def linking
    @linking.sort_by{|t,c| c}.reverse
  end

  def linked_terms
    weight_linked_terms if term.links.empty?
    sorted = term.links.sort_by {|term| term.weight }.reverse
    sorted.map {|link| [link.linked_term.name, link.linked_term_counter, link.linking_term_counter, link.weight]}
  end

  def weight_linked_terms
    @linked = count_linked_terms
    @linking = count_linking_terms

    term.links.clear

    @linked.each do |name, linked_term_counter |
      linking_term_counter =  @linking[name] || 0
      term.links.build linked_term: Term.find_or_build(name, term.language),
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
    responses = fetcher.get_linked_pages(linked_pages)

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

  # ---- categories ----

  def categories
    categories = extractor.categories.map {|c| c[0]}
    found = categories.map do |category|
      Category.where(name: category, language: language).first.try(:name)
    end
    WikiFetcher.new.get_linked_pages(categories - found)
  end


  private

  # list [ {name, text / extractor } ]
  def count_term list
    list.inject({}) do |hash, term|
      hash[term[:name]] ||= 0
      hash[term[:name]] += yield(term)
      hash
    end
  end

end
