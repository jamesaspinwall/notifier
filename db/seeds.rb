# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include Attrs

%w{home work hobby project}.each do |name|
  #puts "Category.create in #{Rails.env}"
  Category.create(name: name)
end

%w{clean meet call program}.each do |name|
  #puts "Tag.create in #{Rails.env}"
  Tag.create(name: name)
end

#if Rails.env == 'development'
puts "Todo.create in #{Rails.env}"
c = Category.find_by(name: 'home')
t = Todo.create(todo_attrs(category: c))
puts "Category: #{t.category.attributes}"
t.tag_ids = Tag.select(:id).all.map(&:id)
puts t.tags.map &:attributes
#end
