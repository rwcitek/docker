#!/usr/bin/env ruby
# composable_spec.rb - mini spec to test module Composable

require 'minitest/autorun'
require '../container/composable.rb'

class Sudo
  include Composable

  def to_s
    'sudo'
  end
end

describe Composable do
  before do
    @sudo =Sudo.new
  end
  describe 'compose' do
    it 'should work for nil prev' do
    @sudo.compose.must_equal 'sudo'
  end
  end
end
