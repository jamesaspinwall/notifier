class Todo < ApplicationRecord

  #validates :complete_at, timeliness: { on_or_after: :created_at, allow_nil: true }
  validates :started_at, timeliness: { on_or_after: :created_at, allow_nil: true }

  belongs_to :category, optional: true
  accepts_nested_attributes_for :category
  has_and_belongs_to_many :tags #, autosave: true
  accepts_nested_attributes_for :tags

  scope :active, -> {
    where(complete_at: nil)
  }
  scope :showable, -> {
    where('show_at is NULL or show_at <= ?', Time.current)
  }

  def build_tags(tag_list_str)
    return if tag_list_str.nil?
    tag_list = tag_list_str.split(',').map(&:strip).reject(&:blank?)
    tags_destroy = []
    tags.each do |tag|
      unless tag_list.include?(tag.name)
        tags_destroy << tag
      end
      tag_list.delete(tag.name)
    end

    tags_destroy.each do |tag|
      tags.destroy tag
    end

    tag_list.each do |name|
      tag = Tag.find_by(name: name)
      unless tag
        tag = Tag.create(name: name)
      end
      tags << tag
    end
  end

end
