# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'net/http'
require 'json'
require 'open-uri'
p "is detroying - #{Movie.all.count}"
Movie.destroy_all
p "destroyed- #{Movie.all.count}"
url = 'https://tmdb.lewagon.com/movie/top_rated'
data = JSON.parse(URI.open(url).read)
data['results'].each do |movie|
  Movie.create(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}",
    rating: movie['vote_average']
  )
end
p "movies created - #{Movie.all.count}"

puts "Creating lists..."
classic = {name: "Classic Movies"}
best60s =  {name: "Best of 60s"}

[classic, best60s].each do |attributes|
  list = List.create(attributes)
  puts "Created #{list.name}"
end

p "lists created : #{List.all.count}"
