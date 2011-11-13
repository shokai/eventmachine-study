#!/usr/bin/env ruby
require 'rubygems'
require 'socket'
require 'eventmachine'

class Sender < EM::Connection
  def post_init
    EM::defer do
      loop do
        send_datagram(Time.now.to_s, 'localhost', 5000)
        sleep 1
      end
    end
  end
  def receive_data data
    port, host = Socket.unpack_sockaddr_in get_peername
    puts "#{host}:#{port} - #{data}"
  end
end

EM::run do
  EM::open_datagram_socket('0.0.0.0', 5001, Sender)
end
