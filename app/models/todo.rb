class Todo < ApplicationRecord

  #validates :complete_at, timeliness: { on_or_after: :created_at, allow_nil: true }
  validates :started_at, timeliness: {on_or_after: :created_at, allow_nil: true}

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

  scope :and_tags_by_names, -> (str) {
    if str.blank?
      all
    else
      arrays_of_todos_array = str.split(',').map(&:strip).map do |name|
        joins(:tags).where(tags: {name: name})
      end
      arrays_of_todos_array.reduce(&:&)
    end
  }

  scope :or_categories_by_names, -> (str) {
    if str.blank?
      all
    else
      names = str.split(',').map(&:strip)
      joins(:category).where(categories: {name: names})
    end
  }

  scope :completed, ->(from_at = Time.current.midnight, to_at = Time.current){
    where(completed_at: from_at..to_at)
  }

  scope

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
