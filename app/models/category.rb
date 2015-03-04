class Category < ActiveRecord::Base
  has_many :parent_relations, foreign_key: :child_id, class_name: 'ParentCategory'
  has_many :children_relations, foreign_key: :parent_id, class_name: 'ParentCategory', dependent: :destroy
  has_many :parents,  through: :parent_relations, class_name: 'Category'
  has_many :children, through: :children_relations, class_name: 'Category'
  has_and_belongs_to_many :terms

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}
end
