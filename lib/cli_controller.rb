require_relative '../config/environment'

class CliController

  def initialize
  @api_test = API_ACCESSOR.new
  end

  def call
    clear_and_reset
    greeting
    command_promt
    goodbye
  end

  def greeting
    puts <<~DOC
     Hello! Welcome to the Satellite Data Retrieval Program!

     Search a list of satellites by name, choose one, and receive
     a bunch of cool data back!

     DOC
    sleep (1)
  end

  def command_promt
    puts <<~DOC
---- Below is a list of commands.  Type one in to get started! ----

    1) populate list < Populates a list of 20 satellites by name.

    2) go to page  < Allows a search of the API by page number

    3) exit < Exits the program.
    DOC

    user_input(gets.strip)
  end


  def list_menu
    clear_and_reset
    puts <<~DOC
    Please select the number of the satellite you wish to know more about
    from the list or type another command

    -----------Commands-----------
              next page
              go to page
              exit
    ------------------------------
    DOC

    @api_test.get_sats
    current_page = @api_test.list_current_page
    puts "You are viewing 20 satellites on #{current_page} of the TLE API ."
    Satellite.all.each_with_index {|sat, index| puts "#{index + 1}. #{sat.name}"}

    input = gets.strip
    if input.to_i == 0
      user_input(input)
    elsif input.to_i > 0
      select_sat(input.to_i)
    end
  end


  def page_select
    clear_and_reset
    puts <<~DOC

    please type in the page number you wish to load
    Page 1 through 436

    DOC

    input = gets
    if input.to_i == 0
      user_input
    elsif input.to_i > 0 && input.to_i < 437
      clear_and_reset
      @api_test.go_to_page(input.to_i)
      list_menu
    else
      puts "Please choose a number between 1 and 436."
      sleep (2)
      page_select
    end
  end


  def goodbye
    puts "Goodbye!"
    exit
  end


  def user_input(input = nil)

      while input != nil
        case input
        when "populate list"
          list_menu
        when "go to page"
          page_select
        when "next page"
          @api_test.go_to_next_page
          list_menu
        when "return"
          clear_and_reset
          list_menu
        when "exit"
          goodbye
        else
          puts "**** I'm sorry, I don't understand that command.  Please try again. ****"
          sleep (2)
          clear_and_reset
          command_promt
        end
      end
  end


  def clear_and_reset
    system "clear"
    Satellite.clear
  end


  def select_sat(new_input)
    if new_input <= Satellite.all.length
      system "clear"
      1.times {Satellite.all[new_input - 1].get_sat_info}
      puts <<~DOC

      Please type "return" to return to the previous list or "go to page" to
      select a a different list.  To close type "exit".
      DOC
      move_on = gets.strip
      user_input(move_on)
    else
      puts "Please choose a number between 1 and #{Satellite.all.length}"
      sleep (2)
      clear_and_reset
      list_menu
    end
  end

end
