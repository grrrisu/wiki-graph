class Term < ActiveRecord::Base
  has_many :links
  has_many :linking, foreign_key: :linked_term_id, class_name: 'Link'
  has_many :linked_terms,  through: :links, class_name: 'Term', dependent: :destroy
  has_many :linking_terms, through: :linking, class_name: 'Term', source: :term

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}

  def self.find_or_fetch name, language = 'de'
    unless term = Term.where(name: name).first
      term = fetch(name, language)
    end
    term
  end

  def self.fetch name, language
    html = WikiFetcher.new(language).get(name)
    attributes = {language: language, name: name }
    attributes.merge! WikiExtractor.new(html).extract_attributes
    term   = Term.create!(attributes)

    parser = WikiParser.parse(name, term.markup)
    parser.weight_linked_terms
    term
  end

end
