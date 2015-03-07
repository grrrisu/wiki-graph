class Link < ActiveRecord::Base
  belongs_to :term, inverse_of: :links
  belongs_to :linked_term, class_name: 'Term', inverse_of: :linking
  has_many :link_categories, inverse_of: :link, dependent: :destroy
  has_many :categories, through: :link_categories, inverse_of: :links
end
