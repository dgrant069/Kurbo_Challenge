require_relative 'helper_module'
require 'pry'

class Weather
  require 'net/http'
  require 'json'
  include Helper
  attr :weather_details

  def initialize(zipcode)
    @weather_details = {}
    @zipcode = zipcode
  end

  def get_weather_info
    @weather_uri = URI("http://api.wunderground.com/api/e5515c259fb2c7b6/forecast10day/q/#{@zipcode}.json")
    @weather_agent = Net::HTTP.get_response(@weather_uri)
    @weather_json = JSON.parse(@weather_agent.body)
  end

  def create_weather_json
    begin
      @weather_json["forecast"]["simpleforecast"]["forecastday"].each do |result|
        date = Time.at(result["date"]["epoch"].to_i)
        if (yday_check(date) - yday_check(Time.new)) <= 7
          @weather_details["#{hash_date_maker(date)}"] = "#{result['conditions']}, with a high of #{result['high']['fahrenheit']} and low of #{result['low']['fahrenheit']}. Average winds of #{result['avewind']['mph']}mph"
        end
      end
    rescue
      puts "\nNo Weather info for this ZIP"
    end
  end
end
