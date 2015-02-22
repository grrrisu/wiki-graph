class WikiParser < WikiCloth::Parser

  include ActionView::Helpers::SanitizeHelper

  attr_reader :html, :text, :term

  def self.parse(name, text)
    new(data: text, term: name)
  end

  def initialize(options)
    super
    @term = options[:term]
    @html = to_html
    @text = strip_tags(@html)
    File.write(Rails.root.join('tmp', 'example.html'), @html)
    File.write(Rails.root.join('tmp', 'example.txt'), @text)
  end

  def linked_terms
    @linked_terms ||= internal_links.uniq
  end

  def weight_linked_terms
    count_linked_terms
    count_on_linked_terms
  end

  def count_linked_terms
    count_term(linked_terms) do |item|
      count_found_term(text, item[1])
    end
  end

  def count_on_linked_terms
    linked_pages = linked_terms.map {|term| term[0] }
    responses = WikiFetcher.new.get_linked_pages(linked_pages)

    count_term(responses) do |item|
      count_found_term(item[1], term)
    end
  end

  def count_found_term text, term
    text.scan(/\b#{term}\b/).size
  end

  def markup
    @parser.options[:data]
  end

  def link_for(page, text)
    ltitle = !text.nil? && text.blank? ? self.pipe_trick(page) : text
    ltitle = page if text.nil?
    self.internal_links << [page, ltitle]
    elem.a(link_attributes_for(page)) { |x| x << ltitle.strip }
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
