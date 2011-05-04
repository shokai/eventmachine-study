#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'socket'

HOST = 'localhost'
PORT = 5000

arr = ['zanmai', 'kazusuke', 'marutaka', 'homu']

EM::run do
  @s = TCPSocket.new(HOST, PORT)
  EM::defer do
    loop do
      puts msg = arr.choice
      @s.puts msg
      sleep 1
    end
  end
  
  EM::defer do
    loop do
      recv = @s.gets
      next if recv.strip.size < 1
      puts recv
    end
  end
end
