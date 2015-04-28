# sudo.rb - class Sudo

require "#{File.dirname(__FILE__)}/composable"

class Docker
  include Composable

  def to_s
  'docker'
  end
end
