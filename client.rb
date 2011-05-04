#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'socket'

arr = ['zanmai', 'kazusuke', 'marutaka', 'homu']

EM::run do
  @s = TCPSocket.open('localhost', 5000)
  EM::defer do
    loop do
      puts msg = arr.choice
      @s.puts msg
      sleep 1
    end
  end
  
  EM::defer do
    loop do
      recv = @s.gets.strip
      next if recv.size < 1
      puts recv
    end
  end
end
