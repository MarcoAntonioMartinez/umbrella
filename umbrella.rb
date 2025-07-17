# Write your solution below!
require "http"
require "json"
require "dotenv/load"

puts "What is your location?"
location = gets.chomp.gsub(" ", "%20")
#location = "Chicago"


maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=" + ENV.fetch("GMAPS_KEY") 

#get response for location
resp = HTTP.get(maps_url)

raw_response = resp.to_s

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

#weather hash
first_result = results[0]

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

lat = loc.fetch("lat")
lon = loc.fetch("lng")

pp lat
=begin
# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_API_KEY") + "/41.8887,-87.6355"

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)

require "json"

parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "The current temperature is " + current_temp.to_s + "."
=end
