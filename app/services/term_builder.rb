# creates or updates a term and all associtations
class TermBuilder

  attr_reader :term

  def initialize name, language = 'de'
    @term = Term.where(name: name, language: language).first_or_initialize
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
    weight_linked_terms unless @weight
    @weight.sort_by {|term, counters| counters.last }.reverse
  end

  def weight_linked_terms
    @linked = count_linked_terms
    @linking = count_linking_terms

    @weight = {}
    @linked.each do |term, count|
      @weight[term] = [] << count
    end
    @linking.each do |term, count|
      @weight[term] << count
    end
    @weight.each do |term, counters|
      @weight[term] << counters[0] + 2 * counters[1].to_i
    end
    @weight
  end

  def count_linked_terms
    count_term(extractor.linked_terms) do |item|
      count_term_in_text(extractor.text, item[:name]) +
      count_term_in_text(extractor.text, item[:text])
    end
  end

  def count_linking_terms
    linked_pages = extractor.linked_terms.map {|term| term[:name] }
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

  # list [ {page, name / extractor } ]
  def count_term list
    list.inject({}) do |hash, term|
      hash[term[:name]] ||= 0
      hash[term[:name]] += yield(term)
      hash
    end
  end

end
