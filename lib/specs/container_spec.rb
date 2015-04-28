#!/usr/bin/env ruby
# container_spec.rb - mini spec Container

require 'minitest/autorun'
require '../container/container.rb'


describe Container do
  before do
    @container=Container.new 'image', 'piper', 'cmd'
  end

it 'should return "create --name=piper, image, cmd"' do
    @container.create.must_equal "create --name='piper' image cmd"
  end
end
