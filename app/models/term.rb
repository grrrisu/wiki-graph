class Term < ActiveRecord::Base
  has_many :links
  has_many :linking, foreign_key: :linked_term_id, class_name: 'Link'
  has_many :linked_terms,  through: :links, class_name: 'Term', dependent: :destroy
  has_many :linking_terms, through: :linking, class_name: 'Term', source: :term

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}

  def self.find_or_create name, language = 'de'
    unless term = Term.where(name: name).first
      term = build(name, language)
    end
    term
  end

  def self.build name, language
    fetcher = WikiFetcher.new(language)
    fetcher.get(name)
    attributes = fetcher.get_attributes.merge(language: language)
    term   = Term.create!(attributes)

    parser = WikiParser.parse(name, markup)
    parser.weight_linked_terms
  end

end
