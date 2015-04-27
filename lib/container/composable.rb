# composable.rb - module for composing composite objects

module Composable
  @previous

  def prev=(value)
    @previous = value
  end

  def prev
    @previous
  end
    def +(that)
    that.prev = this
  end

  def compose
    @prev.nil? ? '' : @prev.compose  + ' ' + this.to_s
  end

end
