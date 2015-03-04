class ParentCategory < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category'
  belongs_to :child, class_name: 'Category'
end
