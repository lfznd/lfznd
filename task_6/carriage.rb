require_relative "manufacturer"

class Carriage
  include Manufacturer
  
  attr_accessor :type 

end
