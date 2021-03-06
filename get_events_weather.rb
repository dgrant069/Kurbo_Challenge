require 'net/http'
require 'json'

# Get user input
print "What zipcode are you in?  "
zipcode = gets.chomp
print "What events are you looking for (example: music)?  "
search_term = gets.chomp.downcase

# I like to have all my variables as close to in one place as possible
meetup_uri = URI("https://api.meetup.com/2/open_events?&sign=true&key=3e6c393c174e554f34475f40762a4f64&text=#{search_term}&&zip=#{zipcode}&radius=5&page=100")
meetup_agent = Net::HTTP.get_response(meetup_uri)
meetup_json = JSON.parse(meetup_agent.body)
meetup_details = {}
dates = []

weather_uri = URI("http://api.wunderground.com/api/e5515c259fb2c7b6/forecast10day/q/#{zipcode}.json")
weather_agent = Net::HTTP.get_response(weather_uri)
weather_json = JSON.parse(weather_agent.body)
weather_details = {}

# So we don't return things that are more than a week out
def yday_check (day)
  if day.yday <= 7
    return day.yday + 365
  else
    return day.yday
  end
end

def hash_date_maker (epoch_date)
  "#{epoch_date.strftime('%A')}, #{epoch_date.strftime('%B')} #{epoch_date.strftime('%e')}, #{epoch_date.strftime('%Y')}"
end

# Meetup converter
begin
  meetup_json["results"].each do |result|
    date = Time.at(result["time"]/1000)
    if (yday_check(date) - yday_check(Time.new)) <= 7
      meetup_details[result["id"]] = {
        date: hash_date_maker(date),
        time: "#{date.strftime('%l%P')}",
        event_name: result["name"],
        group_name: result["group"]["name"]
      }
    end
  end
rescue
  puts "I'm not finding specific events, you sure the Zip or term is right?"
end

# Weather converter
begin
  weather_json["forecast"]["simpleforecast"]["forecastday"].each do |result|
    date = Time.at(result["date"]["epoch"].to_i)
    if (yday_check(date) - yday_check(Time.new)) <= 7
      weather_details["#{hash_date_maker(date)}"] = "#{result['conditions']}, with a high of #{result['high']['fahrenheit']} and low of #{result['low']['fahrenheit']}. Average winds of #{result['avewind']['mph']}mph"
    end
  end
rescue
  puts "\nNo Weather info for this ZIP"
end

# def printer
#   meetup_details
# end

# Combo printer
begin
  meetup_details.each do |id, values|
    day = values[:date]
    values[:weather] = weather_details["#{day}"]
    # printer
    puts "\nDate: #{values[:date]}. @#{values[:time]}\n"
    puts "Event: #{values[:event_name]}\n"
    puts "Hosted by: #{values[:group_name]}\n"
    puts "Weather: #{values[:weather]}\n\n"
  end
rescue
  puts "You sure the Zip is right? No weather info available and no events match that Zip\n Returning all events in the next week for everywhere"
end
