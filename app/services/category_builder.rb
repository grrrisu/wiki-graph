class CategoryBuilder

  attr_reader :term, :extractor

  def initialize term, extractor
    @term = term
    @extractor = extractor
  end

  def fetcher
    @fetcher ||= WikiFetcher.new(term.language)
  end

  def categories(extractor)
    extractor.categories.map {|c| c[:name]}
  end

  def fetch categories
    existing = find categories
    missing  = categories - existing.map(&:name)
    builts   = build_category fetch_multiple(missing)
    existing + builts
  end

  def search_parents parents
    existing  = find parents
    missing   = parents - existing.map(&:name)
    created   = create_category fetch_multiple(missing)
    existing + created
  end

  def build_category responses
    responses.map do |response|
      parents   = search_parents categories(response[:extractor])
      Category.new(name: response[:extractor].name, language: term.language, parents: parents)
    end
  end

  def create_category responses
    responses.map do |response|
      parents = search_parents categories(response[:extractor])
      name = response[:extractor].name
      unless Category.where(name: name, language: term.language).first 
        Category.create(name: name, language: term.language, parents: parents)
      end
    end.compact
  end

  def find category_names
    Category.where(name: category_names, language: term.language)
  end

  def fetch_multiple pages
    fetcher.get_linked_pages(pages)
  end

  def set_categories
    term.categories = fetch categories(extractor)
  end

end