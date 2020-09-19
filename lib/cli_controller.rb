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

    @api_test.get_sats
    Satellite.all.each_with_index {|sat, index| puts "#{index + 1}. #{sat.name}"}

    input = gets.strip


    if input == "exit"
      exit
    end
  end

end


test_two = CliController.new
test_two.call
