class Todo < ApplicationRecord
  belongs_to :category, optional: true
  accepts_nested_attributes_for :category
  has_and_belongs_to_many :tags #, autosave: true
  accepts_nested_attributes_for :tags

  scope :active, -> {
    where(complete_at: nil)
  }
  scope :showable, -> {
    where('show_at <= ?', Time.current)
  }

  def build_tags_not_working(tag_list)
    tag_by_name = {}
    tag_names =[]

    tags.each { |tag|
      tag_by_name[tag.name] = tag
      tag_names << tag.name
    }

    remove_list = (tag_names - tag_list)
    add_list = (tag_list - tag_names)

    remove_list.each do |name|
      tag_by_name[name].destroy
      puts "Destroying: #{name}"
    end


    add_list.each do |name|
      tag = Tag.find_by(name: name)
      if tag
        puts "Adding tag #{tag.name} to ${title}"
      else
        tag = Tag.create(name: name)
        puts "Creating tag #{tag.name} and adding tag to #{title}"
      end
      tags << tag
    end
  end

  def build_tags(tag_list_str)
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

  def build_tags_good(tag_list)
    tags.delete_all
    puts Tag.count
    tag_list.each do |name|
      tag = Tag.find_by(name: name)
      unless tag
        tag = Tag.create(name: name)
      end
      tags << tag
    end
    puts Tag.count
  end
end
