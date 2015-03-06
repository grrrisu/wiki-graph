class Term < ActiveRecord::Base
  has_many :links
  has_many :linking, foreign_key: :linked_term_id, class_name: 'Link'
  has_many :linked_terms,  through: :links, class_name: 'Term', dependent: :destroy
  has_many :linking_terms, through: :linking, class_name: 'Term', source: :term
  has_and_belongs_to_many :categories

  # TODO destroy category if only term

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

  def category_ancestors
    categories.inject([]) do |array, category|
      array << category.ancestors
      array
    end
  end

  def intersect_categories other
    raise ArgumentError if other.nil?
    res = categories.map do |category|
      other.categories.map do |other_category|
        category.intersect(other_category)
      end.sort do |a, b|
        comp = (a[1].to_i <=> b[1].to_i)
        comp.zero? ? (a[2] <=> b[2]) : comp
      end.first
    end.sort do |a, b|
      comp = (a[1].to_i <=> b[1].to_i)
      comp.zero? ? (a[2] <=> b[2]) : comp
    end.uniq do |r| 
      r[0].id
    end.compact

    res.reject do |cat|
      res.any? {|other| other[0].is_child_of?(cat[0]) }
    end
  end

end
