class Category < ActiveRecord::Base
  has_and_belongs_to_many :terms

  validates :name, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: %w{de en}}
end
