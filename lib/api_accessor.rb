require 'rubygems'
require 'httparty'
require 'json'


class Test
  include HTTParty
  base_uri "data.ivanstanojevic.me"



  def search_api_for_sat
    api_url = "/api/tle/"      #sets a variable equal to the Endpoint.
    search_input = "43598"     #sets a variable equal to a users input.
    final_url = "#{api_url}#{search_input}"  #sets a new, final variable equal to a string concat of both Enpoint and user input to pass into the query below.

    response = self.class.get(final_url)    #creates a variable and sets it equal to the response from a query which is dynamically passed by the variable created above.
    body = JSON.parse(response.body)      #creates a variable and sets it equal to the parsed JSON value from the query response.
  end


  def get_sat_data
    all_data = self.search_api_for_sat

    sat_id = all_data["satelliteId"]
    sat_name = all_data["name"]
    launch_date = all_data["date"].split("T")[0]

    puts "Satellite ID: #{sat_id}"
    puts "Satellite Name: #{sat_name}"
    puts "Launch Date: #{launch_date}"

    # puts "Launch Date: #{all_data["date"]}"
  end



end


first_test = Test.new
puts first_test.get_sat_data
