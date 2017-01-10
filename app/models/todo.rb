class Todo < ApplicationRecord
  belongs_to :context#, optional: true
  accepts_nested_attributes_for :context
  has_and_belongs_to_many :tags, autosave: true
  accepts_nested_attributes_for :tags
end
