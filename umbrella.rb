# Write your solution below!
require "http"
require "json"
require "dotenv/load"
require "active_support/all"

puts "What is your location?"
#location = gets.chomp.gsub(" ", "%20")
#location = "Chicago"
location = "Kissimmee"

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

hour = parsed_response.fetch("hourly")

next_hour = hour.fetch("data")

next_hour_temp = next_hour[1].fetch("temperature")

next_hour_sum = next_hour[1].fetch("summary")


puts "The temperature for the next hour is " + next_hour_temp.to_s + "°F and the summary is " + next_hour_sum.to_s + "."

=begin
For each of the next twelve hours, check if the precipitation probability is greater than 10%.
    
      
        
      If so, print a message saying how many hours from now and what the precipitation probability is.
        
      
    
  
    
  
  
    
      If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”

    If not, print “You probably won’t need an umbrella today.”
=end

#precipProbability

count = 1

#maybe get rid of this line
#puts next_hour[3].fetch("precipProbability").to_fs(:percentage, { :precision => 0 } )
#count at 0 = current hour so 1 is next hour
is_rainy = false

=begin
next_hour.each do |hour| 
  if hour.fetch("precipProbability") >= 0.10
    puts "In " + count.to_s + " hours, there is a " + (next_hour[count].fetch("precipProbability") * 100)..to_fs(:percentage, { :precision => 0 } ) + " chance of rain." 
=end

#alternate loop would be with next_hour.each with an if to skip current hour using Time.at or 
    # use range to go from first element + 1 to last element
while count <= 13
 #no need to print all that just check if it is greater than 10 and then break
  if next_hour[count].fetch("precipProbability") >= 0.10
    puts "In " + count.to_s + " hour(s), there is a " + (next_hour[count].fetch("precipProbability") * 100).to_fs(:percentage, { :precision => 0 } ) + " chance of rain." 
    p next_hour[count].fetch("precipProbability")
    is_rainy = true
  break
  
  end

  count+=1
end

if is_rainy
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
