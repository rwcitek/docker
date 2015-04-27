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
    it 'should return sudo for to_s' do
    @sudo.to_s.must_equal 'sudo'
  end

  it 'should have .prev == nil' do
    @sudo.prev.must_equal nil
    end

    it 'should return sudo for compose' do
      @sudo.compose.must_equal 'sudo'
    end
  end
end
