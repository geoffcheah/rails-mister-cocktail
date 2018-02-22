# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

puts "destroying previous seed to prevent duplicates"
Ingredient.destroy_all
Cocktail.destroy_all

puts "seeding database"

url = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
serialized = open(url).read
ingredients = JSON.parse(serialized)

ingredients["drinks"].each do |ingredient|
  ingredient = Ingredient.new(name: ingredient["strIngredient1"])
  ingredient.save!
end

puts "finished!"
