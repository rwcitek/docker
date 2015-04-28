#  container.rb - class Container

require "#{File.dirname(__FILE__)}/composable"

class Container
  include Composable

  def initialize(image, name, command, vols_hash={})
  
  end

  def to_s
  ''
  end
end
