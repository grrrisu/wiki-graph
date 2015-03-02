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

  def self.fetch name, language = 'de'
    builder = TermBuilder.new name, language
    term = builder.create!

    builder.weight_linked_terms.each do |link_item|
      linked_term = Term.where(name: link_item[0]).first_or_create(language: language)
      term.links.create!  linked_term_id: linked_term.id,
                          linked_term_counter: link_item[1][0],
                          linking_term_counter: link_item[1][1],
                          weight: link_item[1][2]
    end

    term
  end

end
