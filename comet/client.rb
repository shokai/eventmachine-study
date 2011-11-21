#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'net/http'
require 'uri'

delay = 3
delay = ARGV.shift.to_i if ARGV.size > 0
puts "GET(comet) -> wait #{delay} sec -> POST"

EM::run do

  EM::defer do
    loop do
      puts "* GET"
      uri = URI.parse 'http://localhost:8080/message'
      res = Net::HTTP.start(uri.host, uri.port).get(uri.path)
      puts res.code
      puts res.body
      EM::stop if res.code.to_i == 200
    end
  end
  
  EM::defer do
    puts "sleep #{delay} sec"
    sleep delay
    
    msg = ['hello!!', 'zanmai', 'kazusuke', 'marutaka'].choice
    post_data = {:body => msg}
    puts "* POST #{msg}"
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
end
