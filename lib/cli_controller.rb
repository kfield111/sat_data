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

    2) "go to page"  < Populates a list of page numbers

    3) "exit" < Exits the program.
    DOC

    input = gets.strip
    if input == "populate list"
        self.list_menu
    elsif input == "exit"
      exit
    elsif input == "go to page"
      self.page_select
    else
      puts "**** I'm sorry, I don't understand that command.  Please try again. ****"
      sleep (2)
      system "clear"
      command_promt
    end
  end

  def list_menu
    system "clear"
    puts <<~DOC
    "Please select the number of the satellite you wish to know more about
    from the list or type another command"

    -----------Commands-----------
              next page
              go to page
              exit
    ------------------------------

    DOC

    @api_test.get_sats
    Satellite.all.each_with_index {|sat, index| puts "#{index + 1}. #{sat.name}"}

    input = gets.strip

    if input.to_i <= Satellite.all.length
      modded_input = input.to_i
      Satellite.all[modded_input - 1].get_sat_info
    elsif input == "exit"
      exit
    else
      puts "**** Please choose a number between 1 and 20. ****"
      sleep (2)
      system "clear"
      list_menu
    end
    end
  end


  def page_select
    puts <<~DOC

    please type in the page number you wish to load
    Page 1 through 435

    DOC
    input = gets.chomp.to_i
    @api_test.go_to_page(input)
    list_menu

    if input != (1..435)
      puts "**** Please choose a number between 1 and 435. ****"
      sleep (2)
      system "clear"
      page_select
    end

  end

end


test_two = CliController.new
test_two.call
