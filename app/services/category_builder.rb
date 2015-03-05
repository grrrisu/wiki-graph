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
    @cache = Set.new
    existing = find categories
    missing  = categories - existing.map(&:name)
    builts   = build_category fetch_multiple(missing)
    # ... go up the tree ...
    existing + builts
  end

  def search_parents parents
    existing  = find parents
    missing   = parents - existing.map(&:name)
    created   = create_category fetch_multiple(missing)
    # .... go up the tree ....
    existing + created
  end

  def build_category responses
    responses.map do |response|
      parents   = search_parents categories(response[:extractor])
      # ... go up the tree ....
      Category.new(name: response[:extractor].name, language: term.language, parents: parents)
    end
  end

  def create_category responses
    responses.map do |response|
      parents = search_parents categories(response[:extractor])
      Rails.logger.info "***** parents: #{parents.map(&:name)}"
      raise "Category #{response[:extractor].name} already exists!!!" if @cache.include? response[:extractor].name 
      cat = Category.create(name: response[:extractor].name, language: term.language, parents: parents)
      @cache.add response[:extractor].name
      Rails.logger.info "***** Category #{response[:extractor].name} created"
      cat
    end
  end

  def find category_names
    Category.where(name: category_names, language: term.language).to_a
  end

  def fetch_multiple pages
    fetcher.get_linked_pages(pages)
  end

  def set_categories
    term.categories = fetch categories(extractor)
  end

end