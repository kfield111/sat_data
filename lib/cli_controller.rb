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

    1) "Populate List" < Populates a list of 20 satellites by name.

    2) "goto page X"  < Populates a list of 20 satellites by name on the given page.

    3) "Exit" < Exits the program.
    DOC

    input = nil
    input = gets.strip
    while input != "Exit"
      case input
      when "Populate List"
        self.list_menu
      end
    end
  end

  def list_menu
    puts "Please select the satellite you wish to know more about."

    input = nil
    input = gets.strip
    if input != "exit"
      puts "searching for #{input}"
      @api_test.get_sat_data(input)
    elsif input == "exit"
      exit
    end
  end

end


test_two = CliController.new
test_two.call
