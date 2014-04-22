require_relative 'helper_module'
require 'pry'

class Meetup
  require 'net/http'
  require 'json'
  include Helper
  attr :meetup_details

  def initialize (zipcode, search_term)
    @meetup_details = {}
    @zipcode = zipcode
    @search_term = search_term
  end

  def get_meetup_info
    @meetup_uri = URI("https://api.meetup.com/2/open_events?&sign=true&key=3e6c393c174e554f34475f40762a4f64&text=#{@search_term}&&zip=#{@zipcode}&radius=5&page=100")
    @meetup_agent = Net::HTTP.get_response(@meetup_uri)
    @meetup_json = JSON.parse(@meetup_agent.body)
  end

  def create_meetup_json
    begin
      # binding.pry
      @meetup_json["results"].each do |result|
        date = Time.at(result["time"]/1000)
        if (yday_check(date) - yday_check(Time.new)) <= 7
          @meetup_details[result["id"]] = {
            date: hash_date_maker(date),
            time: "#{date.strftime('%l%P')}",
            event_name: result["name"],
            group_name: result["group"]["name"]
          }
        end
      end
    rescue
      puts "\nI'm not finding specific events, you sure the Zip or term is right?"
    end
  end
end
