class LinkCategory < ActiveRecord::Base
  belongs_to :link, inverse_of: :link_categories
  belongs_to :category, inverse_of: :link_categories
end
