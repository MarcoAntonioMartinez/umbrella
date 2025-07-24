# Write your solution below!
require "http"
require "json"
require "dotenv/load"
require "active_support/all"
require "ascii_charts"

puts "========================================"
puts "   Will you need an umbrella today?"
puts "========================================\n\n"

puts "What is your location?"

location = gets.chomp.gsub(" ", "%20").capitalize
#location = "Chicago"
#location = "Kissimmee"

puts "Checking the weather at " + location + "...."

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


# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + lat.to_s + "," + lon.to_s


# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)

parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "The current temperature is " + current_temp.to_s + "°F."

#for getting hourly precipProbability
next_hour = parsed_response.fetch("hourly").fetch("data")

#to get summary that would happen within the hour
minute = parsed_response.fetch("minutely")

summary = minute.fetch("summary")

puts "Next hour: " + summary + "."


#count for hour index, 0 is current hour
count = 1
is_rainy = false

#alternate loop would be with next_hour.each with an if to skip current hour using Time.at or 
    # use range to go from first element + 1 to last element

#keep track of probabilities
rain_chance = []
while count <= 12
  
 #break once probability > 10% is found
 if next_hour[count].fetch("precipProbability") >= 0.10
    puts "In " + count.to_s + " hour(s), there is a " + (next_hour[count].fetch("precipProbability") * 100).to_fs(:percentage, { :precision => 0 } ) + " chance of rain." 
    
    is_rainy = true
  break
  
  end

  count+=1
end

#loop through next 12 hrs to make y axis (rain chance)
next_hour[1..12].each_with_index do |h, count|
  
  rain_chance.push((h.fetch("precipProbability") * 100).to_i)
  #hours.push(count)

end

#Make the histogram for rain chance
puts AsciiCharts::Cartesian.new((1..12).to_a.map{|x| [x, rain_chance[x-1]]}, :bar => true, :hide_zero => true, :title => "Hours from now vs Precipation probability" ).draw



if is_rainy
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
