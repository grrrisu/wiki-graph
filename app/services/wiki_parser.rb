class WikiParser < WikiCloth::Parser

  include ActionView::Helpers::SanitizeHelper

  attr_reader :html, :text

  def self.parse(text)
    new(data: text)
  end

  def initialize(options)
    super
    @html = to_html
    @text = strip_tags(@html)
    File.write(Rails.root.join('tmp', 'example.html'), @html)
    File.write(Rails.root.join('tmp', 'example.txt'), @text)
  end

  def linked_terms
    @linked_terms ||= internal_links.uniq
  end

  def weight_linked_terms
    linked_terms.inject({}) do |hash, linked_term|
      found = html.scan(/\b#{linked_term[1]}\b/).size
      hash[linked_term[0]] ||= 0
      hash[linked_term[0]] += found
      hash
    end.sort_by do |key, value|
      value
    end.reverse
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

end
