require 'rubygems'
require 'httparty'
require 'json'


class API_ACCESSOR
  include HTTParty      #necessary to allow HTTParty to operate correctly in this class
  base_uri "data.ivanstanojevic.me"   #sets the base homepage url for the httparty gem


def response
  response = self.class.get('/api/tle/')    #the initial get query to the api endpoint.
  @list_body = JSON.parse(response.body)      #parses the response and sets it equal to an instance variable.
end


  @@full_list = []      #creates a variable set to an empty array to be populated with satellite names by the while loop below.

  def get_sat_name_and_id (url)    #a method that iterates through each page of the API and returns an array of extracted satellite ID's and names.
    current_page = @list_body["view"]["@id"].split("?")[1].tr("=", "")   #creates a variable and assigns it to the value of the current page and formats it to a more pleasing form.
    @list_body["member"].each do |temp|      #iterates over the 20 (max) satellites in the current page stored in the "member" key.
      @@full_list << temp['name']         #shovels the names of each satellite into the full_list array.
    end
    puts "Currently displaying results from #{current_page}"  #indicates to the user which page of the API they are currently viewing.
    @@full_list.each_with_index do |value, index|  #returns the collective names of all satellites shoveled into the array during the loop
      puts "#{index+1}. #{value}"
    end
  end

  def go_to_next_page     #a mpthod that clears the current list of satellites and then displays the satellites on page 2 of the API.
    @@full_list.clear     #clears the current array of satellite names in the array.
    next_page = @list_body["view"]["next"].split("?")[1]      #creates a variable to store the nested value of "next" within the variable assigned to the query response and formats it.

    while @list_body["view"]["next"] == "https://data.ivanstanojevic.me/api/tle?#{next_page}"   #creating a loop that runs unit the query reaches a specific page number of the API pulled form the variable above.
      next_page_address = @list_body["view"]["next"]  #sets a variable equal to the html address of the next page of the API.
      list = self.class.get(next_page_address)     #increments the url by resetting it to the "next" value we stored above.
      @list_body = JSON.parse(list.body)    #parses the new response.
      puts "moving to #{next_page}"    #lists to the user which page the loop is going to next.
    end
    get_sat_name_and_id (next_page_address)   #calls the shown method and passes in the updated html address in order to show the new group of satellite names.
  end


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
first_test.response
1.times {puts first_test.go_to_next_page}
