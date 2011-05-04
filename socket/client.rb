#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'

HOST = 'localhost'
PORT = 5000
RECONNECT_INTERVAL = 5

@@arr = ['zanmai', 'kazusuke', 'marutaka', 'homu']

class Client < EM::Connection
  def post_init
    EM::defer do
      loop do
        puts msg = @@arr.choice
        send_data msg
        sleep 1
      end
    end
  end

  def receive_data(data)
    puts data
  end

  def unbind
    puts "connection closed - #{HOST}:#{PORT}"
    EM::add_timer(RECONNECT_INTERVAL) do
      reconnect(HOST,  PORT)
    end
  end
end

EM::run do
  EM::connect(HOST, PORT, Client)
end
