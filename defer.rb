#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
$KCODE = 'u'

EventMachine::run{
  EventMachine::defer{
    loop do
      puts 'a'
      sleep 0.1
    end
  }
  EventMachine::defer{
    loop do
      puts 'b'
      sleep 0.1
    end
  }
}

