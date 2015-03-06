class Link < ActiveRecord::Base
  belongs_to :term
  belongs_to :linked_term, class_name: 'Term'
  has_many :link_categories, dependent: :destroy
  has_many :categories, through: :link_categories
end
