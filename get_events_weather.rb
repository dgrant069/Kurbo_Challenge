require_relative 'meetup_class'
require_relative 'weather_class'
require 'pry'

# Get user input
print "What zipcode are you in?  "
@zipcode = gets.chomp
print "What events are you looking for (example: music)?  "
@search_term = gets.chomp.downcase

meetup = Meetup.new(@zipcode, @search_term)
weather = Weather.new(@zipcode)

meetup.get_meetup_info
meetup.create_meetup_json

weather.get_weather_info
weather.create_weather_json

# Combo printer
begin
  meetup.meetup_details.each do |id, values|
    day = values[:date]
    values[:weather] = weather.weather_details["#{day}"]
    # printer
    puts "\nDate: #{values[:date]}. @#{values[:time]}\n"
    puts "Event: #{values[:event_name]}\n"
    puts "Hosted by: #{values[:group_name]}\n"
    puts "Weather: #{values[:weather]}\n\n"
  end
rescue
  puts "You sure the Zip is right? No weather info available and no events match that Zip\n Returning all events in the next week for everywhere"
end
