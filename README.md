Read Me
==============================

Events and Weather API Masher
------------------------------

### How to use?
Run the following script in your CLI:
'<$ ruby get_events_weather.rb>'


### What is it doing?
This script uses Ruby's built in Net::http class to connect and interact with 2
APIs - Wunderground's weather API and Meetup's event API.
I save the specific JSON received from API that I want (dates, weather info, event places, etc) into a hash.
I then add "value" (the weather info) from the weather hash to the Meetup hash, based on the key (the dates).

### What were the steps?
1. Identify the API's to use - 1h
2. Get an API key for each - 15m
3. Read documentation for how to call, what info/methods are available, and what the response looks like - 4h
4. Play with JSON to get the data I wanted from each - 1h
5. Design/write methods to pull out and reassemble the data in the way I want - 4h
6. Combine them and display to CLI - 1h
7. Readme - 30m
