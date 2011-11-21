#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-http'

EM::run do
  http = EM::HttpRequest.new('http://localhost:8080/message').get
  http.callback do |res|
    puts "GET success"
    puts res.response_header.status
    puts res.response
    EM::stop
  end
  http.errback do |err|
    puts "GET error"
    puts err.response_header.status
    puts err.error
    puts err.response
  end
  
  puts "sleep 3 sec"
  sleep 3
  
  post_data = {:body => "shokai"}
  http = EM::HttpRequest.new('http://localhost:8080/message').post(post_data)
  http.callback do |res|
    puts "POST success"
    puts res.response_header.status
    puts res.response
  end
  http.errback do |err|
    puts "POST error"
    puts err.response_header.status
    puts err.error
    puts err.response
  end
end
