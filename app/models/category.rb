class Category < ActiveRecord::Base
  has_many :parent_relations, foreign_key: :child_id, class_name: 'ParentCategory'
  has_many :children_relations, foreign_key: :parent_id, class_name: 'ParentCategory', dependent: :destroy
  has_many :parents,  through: :parent_relations, class_name: 'Category'
  has_many :children, through: :children_relations, class_name: 'Category'
  has_and_belongs_to_many :terms

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}

  # TODO destroy child if no other parent, destroy parent if only child

  def self.root language = 'de'
    includes(:parents).where(language: language, parent_categories: {parent_id: nil}).first
  end

  def ancestors depth = 0, previous = {}, &block
    value = block_given? ? yield(self) : self
    previous[depth] ||= Set.new
    current = previous.merge(depth => previous[depth] << value)
    parents.each do |parent|
      current = parent.ancestors depth + 1, current, &block
    end
    current
  end

end
