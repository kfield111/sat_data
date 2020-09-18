require './lib/environment'

class CliController

  def initialize
  @api_test = API_ACCESSOR.new
  end

  def call
    greeting
    command_promt
  end

  def greeting
    puts "Hello! Welcome to the Satellite Data Retrieval Program!"
  end

  def command_promt
    puts "Below is a list of commands.  Type one in to get started!"
    puts <<~DOC

    1) "populate list" < Populates a list of 20 satellites by name.

    2) "goto page X"  < Populates a list of 20 satellites by name on the given page.

    3) "exit" < Exits the program.
    DOC

    input = gets.strip
    if input == "populate list"
        self.list_menu
    else
      puts "I'm sorry, I don't understand that command.  Please try again."
      command_promt
    end
  end

  def list_menu
    system "clear"
    puts <<~DOC
    "Please select the satellite you wish to know more about or type another command"
    Commands:
              next page
              go to page (x)
              exit
    DOC

  @list_number = @api_test.get_sat_name_and_id

    input = gets.chomp.to_i


    if input <= @list_number.length
      test_five = @api_test.response["member"]["satelliteId"]
      puts test_five
      elsif input == "next page"
      puts "going to next page"    #Test must replace later
    elsif input == "exit"
      exit
    else
      self.list_menu
    end
  end

end


test_two = CliController.new
test_two.call
