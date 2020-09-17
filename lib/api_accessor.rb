require 'rubygems'
require 'httparty'
require 'json'


class API_ACCESSOR
  include HTTParty      #necessary to allow HTTParty to operate correctly in this class
  base_uri "data.ivanstanojevic.me"   #sets the base homepage url for the httparty gem



  def search_api_for_sat
    api_url = "/api/tle/"      #sets a variable equal to the Endpoint.
    search_input = "25544"     #sets a variable equal to a users input.
    final_url = "#{api_url}#{search_input}"  #sets a new, final variable equal to a string concat of both Enpoint and user input to pass into the query below.

    response = self.class.get(final_url)    #creates a variable and sets it equal to the response from a query which is dynamically passed by the variable created above.
    body = JSON.parse(response.body)      #creates a variable and sets it equal to the parsed JSON value from the query response.
  end


  def get_sat_data    #method used for gathering the data returned from the search_api_for_sat method and seperating it out into a readable format for end user.
    all_data = self.search_api_for_sat    #creates a variable and sets it equal to the return of the search_api_for_sat method, which is a hash of all the sat data.

    sat_id = all_data["satelliteId"]                    #the following lines of code extract specific data and assign that data to varibles
    sat_name = all_data["name"]
    ballistic_coef = all_data["line1"].split[4]
    inclination = all_data["line2"].split[1]


    designator = all_data["line1"].split[2]             #the following lines of code convert the data format from the api into a readable format to display which number this satellite launch was.
    number_launched = "#{designator[2]}#{designator[3]}#{designator[4]}"


    launch_date = all_data["line1"].split[2]              #the following lines of code convert the data format from the api into a readable year format.
    launch_year = "#{launch_date[0]}#{launch_date[1]}"
    if launch_date[0] == "9"
      launch_year_full = "19#{launch_year}"
    elsif launch_date[1] == "0"
      launch_year_full = "20#{launch_year}"
    end



    puts "Satellite ID: #{sat_id}"              #the following lines of code puts out the specified extracted data for the end user
    puts "Satellite Name: #{sat_name}"
    puts "Launch Year: #{launch_year_full}"
    puts "Launch Number: #{number_launched}"
    puts "Ballistic Coefficient: #{ballistic_coef}"
    puts "Inclination: #{inclination}"

    # puts "Launch Date: #{all_data["date"]}"
  end



end


first_test = API_ACCESSOR.new
puts first_test.get_sat_data
