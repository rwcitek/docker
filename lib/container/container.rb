#  container.rb - class Container

require "#{File.dirname(__FILE__)}/composable"

class Container
  include Composable

  def initialize(image, name, command, vols_hash={})
  @tmp_str = ''  
  @image=image
    @name=name
    @cmd=command
  end

  def to_s
 @tmp_str 
  end

  def create
  "create --name='#{@name}' #{@image} #{@cmd}"
  end
end
