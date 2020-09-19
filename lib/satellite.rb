require './lib/environment'

class Satellite
  attr_accessor :name, :id, :launch_year, :ballistic_coef, :inclination

  @@all = []

  def initialize
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


end
