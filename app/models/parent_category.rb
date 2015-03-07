class ParentCategory < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category', inverse_of: :parent_relations
  belongs_to :child, class_name: 'Category', inverse_of: :children_relations
end
