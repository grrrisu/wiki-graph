class Term < ActiveRecord::Base
  has_many :links
  has_many :linking, foreign_key: :linked_term_id, class_name: 'Link'
  has_many :linked_terms,  through: :links, class_name: 'Term', dependent: :destroy
  has_many :linking_terms, through: :linking, class_name: 'Term', source: :term
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}

  def self.find_or_fetch name, language = 'de'
    builder = TermBuilder.new(name, language)
    builder.fetch! if builder.term.new_record?
    builder.term
  end

  def self.find_or_fetch_without_links name, language = 'de'
    builder = TermBuilder.new(name, language)
    builder.fetch_without_links if builder.term.new_record?
    builder.term
  end

  def self.find_or_build(name, language)
    Term.where(name: name, language: language).first_or_initialize
  end

end
