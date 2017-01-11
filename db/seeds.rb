# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

%w{home work hobby project}.each do |name|
  puts "Category.create in #{Rails.env}"
  Category.create(name: name)
end

%w{clean meet call}.each do |name|
  puts "Tag.create in #{Rails.env}"
  Tag.create(name: name)
end

if Rails.env == 'development'
  puts "Todo.create in #{Rails.env}"
  Todo.create(Attrs.todo)
end
