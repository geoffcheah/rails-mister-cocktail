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
Cocktail.destroy_all
Dose.destroy_all
Ingredient.destroy_all


puts "seeding database"
# seeding ingredients
url = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
serialized = open(url).read
ingredients = JSON.parse(serialized)

ingredients["drinks"].each do |ingredient|
  ingredient = Ingredient.new(name: ingredient["strIngredient1"])
  ingredient.save!
end

# Seeding cocktails and doses
# getting ids for cocktails to use to create cocktails later
get_cocktail_id_url = "http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
drinks_serialized = open(get_cocktail_id_url).read
drinks = JSON.parse(drinks_serialized)

id_array = []
drinks["drinks"].each do |drink|
  id_array << drink["idDrink"].to_i
end

# creating cocktails using the id_array
id_array.each do |id|
  cocktail_url = "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{id}"
  cocktail_serialized = open(cocktail_url).read
  cocktail = JSON.parse(cocktail_serialized)
  cocktail_hash = cocktail["drinks"].first
  new_cocktail = Cocktail.new(name: cocktail_hash["strDrink"])
  new_cocktail.save
  15.times do |i|
    new_dose = Dose.new(description: cocktail_hash["strMeasure#{i}"])
    new_dose.cocktail = new_cocktail
    new_dose.ingredient = Ingredient.find_by_name(cocktail_hash["strIngredient#{i}"])
    new_dose.save
  end
end

puts "finished!"

