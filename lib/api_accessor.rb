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


  def get_sats (url = 0)    #a method that provides a numbered list of satellites for the user to choose from.
    current_page = @list_body["view"]["@id"]         #["view"]["@id"].split("?")[1].tr("=", "").gsub("search", "").tr("&", "")
    @list_body["member"].each do |temp|
      Satellite.create_from_api(temp)
    end
    response (current_page)
  end


  def go_to_next_page     #a method that calls and loads the next page of the API.
    next_page = @list_body["view"]["next"]
    response (next_page)
  end


  def go_to_page (input)  #a method that allows a user to go to a specific page within the API.
    user_page_input = "https://data.ivanstanojevic.me/api/tle?page=#{input}"  #sets a variable to an html address with the page number set by user.
    response (user_page_input)    #updates the json parse query.
  end


end

#--------------development/test code below this line ----------------------

#
# first_test = API_ACCESSOR.new
# 4.times {puts first_test.go_to_next_page}
