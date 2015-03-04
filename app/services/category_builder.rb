class CategoryBuilder

  attr_reader :term, :extractor

  def initialize term, extractor
    @term = term
    @extractor = extractor
  end

  def categories
    extractor.categories.map {|c| c[:name]}
  end

  def fetch
    existing = find categories
    missing  = categories - existing.map(&:name)
    builts   = build fetch_multiple(missing)
    existing + builts
  end

  def build responses
    responses.map do |response|
      Category.new name: response[:extractor].name, language: term.language
    end
  end

  def find categories
    categories.map do |category|
      Category.where(name: category, language: term.language).first.try(:name)
    end.compact
  end

  def fetch_multiple pages
    WikiFetcher.new(term.language).get_linked_pages(pages)
  end

  def set_categories
    term.categories = fetch
  end

end