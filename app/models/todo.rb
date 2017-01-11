class Todo < ApplicationRecord
  belongs_to :category, optional: true
  accepts_nested_attributes_for :category
  has_and_belongs_to_many :tags, autosave: true
  accepts_nested_attributes_for :tags
end
