class Link < ActiveRecord::Base
  belongs_to :term
  belongs_to :linked_term, class_name: 'Term'
end
