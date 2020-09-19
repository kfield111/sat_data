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

    if input.to_i > 0
      int_input = input.to_i
    else
      string_input = input
    end

    while input = int_input
      if int_input <= Satellite.all.length
        Satellite.all[int_input - 1].get_sat_info
      elsif int_input >= Satellite.all.length
        puts "**** Please choose a number between 1 and #{Satellite.all.length}. ****"
        sleep (2)
        system "clear"
        Satellite.clear
        list_menu
      end
    end

    while input = string_input
      if string_input == "exit"
        exit
      elsif string_input == "go to page"
        self.page_select
      else
        puts "**** I'm sorry, I don't understand that command.  Please try again. ****"
        sleep (2)
        system "clear"
        Satellite.clear
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

    if input >= 1 && input <= 435
      @api_test.go_to_page(input)
      list_menu
    elsif input != (1..435)
      puts "**** Please choose a number between 1 and 435. ****"
      sleep (2)
      system "clear"
      page_select
    end
  end

end


test_two = CliController.new
test_two.call
