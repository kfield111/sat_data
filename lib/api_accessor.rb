require './lib/environment'

class API_ACCESSOR
  include HTTParty      #necessary to allow HTTParty to operate correctly in this class
  base_uri "data.ivanstanojevic.me"   #sets the base homepage url for the httparty gem

  def initialize
    response
  end


  def response (url = "/api/tle?search=")
  response = self.class.get(url)    #the initial get query to the api endpoint.
  @list_body = JSON.parse(response.body)      #parses the response and sets it equal to an instance variable.
  end


  @@full_list = []      #creates a variable set to an empty array to be populated with satellite names by the while loop below.

  def get_sats (url = 0)    #a method that provides a numbered list of satellites for the user to choose from.
    current_page = @list_body["view"]["@id"].split("?")[1].tr("=", "").gsub("search", "").tr("&", "")   #creates a variable and assigns it to the value of the current page and formats it to a more pleasing form.
    @list_body["member"].each do |temp|
      Satellite.create_from_api(temp)
    end

  end


  def go_to_next_page     #a method that clears the current list of satellites and then displays the satellites on the next page of the API.
    @@full_list.clear     #clears the current array of satellite names in the array.
    next_page = @list_body["view"]["next"]..split("?")[1].tr("=", "").gsub("search", "").tr("&", "")      #creates a variable to store the nested value of "next" within the variable assigned to the query response and formats it.

    while @list_body["view"]["next"] == "https://data.ivanstanojevic.me/api/tle?#{next_page}"   #creating a loop that runs unit the query reaches a specific page number of the API pulled form the variable above.
      next_page_address = @list_body["view"]["next"]  #sets a variable equal to the html address of the next page of the API.
      list = self.class.get(next_page_address)     #increments the url by resetting it to the "next" value we stored above.
      @list_body = JSON.parse(list.body)    #parses the new response.
      puts "moving to #{next_page}"    #tells the user which page the loop is going to next.
    end
    get_sat_names (next_page_address)   #calls the get_sat_name_and_id method and passes in the updated html address in order to show the new group of satellite names.
  end


  def go_to_page (input)  #a method that allows a user to go to a specific page within the API.
    @@full_list.clear     #clears the current array of satellite names in the array.
    user_page_input = "https://data.ivanstanojevic.me/api/tle?page=#{input}"  #sets a variable to an html address with the page number set by user.
    response (user_page_input)    #updates the json parse query.
    get_sats     #populates the new list from the users entered page.
  end



  def search_api_for_sat (input = 0)     #method that locates data within the API on the satellite chosen by the user.
    api_url = "/api/tle/"      #sets a variable equal to the Endpoint.
    search_input = "#{input}"     #sets a variable equal to a users input.
    final_url = "#{api_url}#{search_input}"  #sets a new, final variable equal to a string concat of both Enpoint and user input to pass into the query below.

    response = self.class.get(final_url)    #creates a variable and sets it equal to the response from a query which is dynamically passed by the variable created above.
    body = JSON.parse(response.body)      #creates a variable and sets it equal to the parsed JSON value from the query response.
  end


end

#development/test code below this line ----------------------
#
# first_test = API_ACCESSOR.new
# puts first_test.get_sats
