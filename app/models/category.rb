class Category < ApplicationRecord
  validates :name, uniqueness: true
  scope :by_names, -> (str) {
    where(name: str.split(',').map(&:strip))
  }
end
