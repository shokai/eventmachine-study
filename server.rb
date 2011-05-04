#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'eventmachine'


@@channel = EM::Channel.new

class EchoHandler < EM::Connection
  def post_init
    @sid = @@channel.subscribe{|mes|
      send_data mes
    }
    @@channel.push "new client <#{@sid}> connected\n"
  end

  def receive_data data
    return if data.strip.size < 1
    puts "<#{@sid}> #{data}"
    send_data "echo to <#{@sid}> : #{data}"
  end
end

EM::run do
  EM::start_server('localhost', 5000, EchoHandler)

  EM::defer do
    loop do
      puts msg = "this is broadcast message : #{Time.now.to_s}\n"
      @@channel.push msg
      sleep 10
    end
  end
end
