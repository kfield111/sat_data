require_relative '../config/environment.rb'

class Satellite
  attr_accessor :name, :id, :launch_year, :ballistic_coef, :inclination

  @@all = []

  def initialize (name, id, launch_year, ballistic_coef, inclination)
    @name = name
    @id = id
    @launch_year = launch_year
    @ballistic_coef = ballistic_coef
    @inclination = inclination
    @@all << self
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end


  def self.create_from_api (sat)
    sat_name = sat["name"]
    sat_id = sat["satelliteId"]

    launch_date = sat["line1"].split[2]           #the following lines of code convert the data format from the api into a readable year format.
    launch_year = "#{launch_date[0]}#{launch_date[1]}"
    launch_edit = launch_year.to_i
    if launch_edit > 20
      launch_year_full = "19#{launch_year}"
    elsif launch_edit < 20
      launch_year_full = "20#{launch_year}"
    end
    sat_ball_co = sat["line1"].split[4]
    sat_incln = sat["line2"].split[2]

    new_sat = self.new(sat_name, sat_id, launch_year_full, sat_ball_co, sat_incln)
  end

  def get_sat_info
    puts <<~DOC
    ---------------------#{name}-----------------------
    Satelite Name: #{name}
    Satellite ID: #{id}
    Satellite Launch Year: #{launch_year}
    Satellite Ballistic Coefficient:  #{ballistic_coef}
    Satellite Inclination: #{inclination}
    -----------------------------------------------------
    DOC

  end

end
