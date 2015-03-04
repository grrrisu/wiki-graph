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

  def link_builder
    @link_builder ||= LinkBuilder.new(term, extractor)
  end

  def category_builder
    CategoryBuilder.new(term, extractor)
  end

  def fetch
    set_name
    term.categories = category_builder.fetch
    link_builder.weight_linked_terms
    term
  end

  def fetch!
    fetch.save!
  end

  def set_name
    name = extractor.name
    term.name =  name if name.present?
  end

  def linked_terms
    link_builder.weight_linked_terms if term.links.empty?
    sorted = term.links.sort_by {|term| term.weight }.reverse
    sorted.map {|link| [link.linked_term.name, link.linked_term_counter, link.linking_term_counter, link.weight]}
  end

  # ---- categories ----

  

end
