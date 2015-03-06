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

  def ancestors &block
    @ancestors ||= find_ancestors &block
  end

  def find_ancestors depth = 0, previous = {}, &block
    value = block_given? ? yield(self) : self
    previous[depth] ||= Set.new
    current = previous.merge(depth => previous[depth] << value)
    parents.each do |parent|
      current = parent.find_ancestors depth + 1, current, &block
    end
    current
  end

  def intersect other
    current = self.ancestors
    others = other.ancestors

    current.each do |depth, set|
      others.each do |other_depth, other_set|
        if set.intersect? other_set
          return [set.intersection(other_set).first, depth, other_depth]
        end
      end
    end
    [Category.root, 100, 100]
  end

  def is_child_of? other
    current = self.ancestors
    return false if self.id == other.id

    current.each do |depth, set|
      return true if set.include? other
    end
    false
  end

end
