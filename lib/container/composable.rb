# composable.rb - module for composing composite objects

module Composable
  @prev

    def +(that)
    that.prev = this
  end

  def compose
    @prev.nil? ? '' : @prev.compose  + ' ' + this.to_s
  end

end
