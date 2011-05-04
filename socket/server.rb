#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'

HOST = '0.0.0.0'
PORT = 5000

@@channel = EM::Channel.new

class EchoServer < EM::Connection
  def post_init
    @sid = @@channel.subscribe{|mes|
      send_data mes
    }
    puts "new client <#{@sid}>"
    @@channel.push "new client <#{@sid}> connected\n"
  end

  def receive_data data
    return if data.strip.size < 1
    puts "<#{@sid}> #{data}"
    send_data "echo to <#{@sid}> : #{data}\n"
  end

  def unbind
    puts "unbind <#{@sid}>"
    @@channel.unsubscribe(@sid)
  end
end

EM::run do
  EM::start_server(HOST, PORT, EchoServer)

  EM::add_periodic_timer(5) do
    puts msg = "this is broadcast message : #{Time.now.to_s}\n"
    @@channel.push msg
  end
end
