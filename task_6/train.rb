require_relative "manufacturer"
require_relative "instance_counter"
require_relative "validate"

class Train
  include Manufacturer
  include InstanceCounter
  include Validate

  attr_accessor :carriage, :speed, :station, :route, :type, :carriages, :number

  NUMBER_FORMAT = /^[а-яa-zА-ЯA-Z\d]{3}[-]?[а-яa-zА-ЯA-Z\d]{2}$/i
  NUMBER_FORMAT_ERROR = "Неверный формат номера"
  
  @@trains = {}

  def initialize(number, speed = 0)
    @number = number
    @type = type
    @speed = speed
    @carriages = []
    validate!
    @@trains[number] = self
    register_instance
  end

  def self.find(number)
    @@trains[number]
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero?
  end

  def remove_carriage(carriage)
    return if speed != 0
    @carriages.delete(carriage) if @carriages.include?(carriage)
  end

  def stop
    @speed = 0
  end

  def go(speed)
    @speed += speed 
  end

  def current_speed
    @speed
  end

  def add_route(route)
    @station = route.stations.first
    @station.get_train(self)
    @route = route
  end

  def next_station
    route.stations[route.stations.index(station) + 1] if @station != route.stations.last
  end

  def prev_station
    route.stations[route.stations.index(station) -1] if @station != route.stations.first
  end

  def move_next
    if next_station
      @station.send_train(self)
      @station = next_station 
      @station.get_train(self)
    else
      return 
    end
  end

  def move_prev
    if prev_station
      @station.send_train(self)
      @station = prev_station
      @station.get_train(self)
    else
      return 
    end
  end

  protected

  def validate!
    raise NUMBER_FORMAT_ERROR if number !~ NUMBER_FORMAT
  end
end
