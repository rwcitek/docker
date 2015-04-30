#!/usr/bin/env ruby
# composable_spec.rb - mini spec to test module Composable

require 'minitest/autorun'
require '../container/sudo'
require '../container/docker'


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



describe 'compose two objects' do
  before do
    @docker = Sudo.new + Docker.new
  end

  it 'should be instance of Docker' do
    @docker.class.name.must_equal 'Docker'
  end
   it 'should return docker for Docker.to_s' do
    @docker.to_s.must_equal 'docker'
  end

  it 'should return "sudo docker"' do
    @docker.compose.must_equal 'sudo docker'
  end
end
