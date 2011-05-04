#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer
 
  def process_http_request
    res = EventMachine::DelegatedHttpResponse.new(self)

    puts "request_method : #{@http_request_method}"
    puts "path_info : #{@http_path_info}"
    puts "query_str : #{@http_query_string}"
    puts "post_content : #{@http_post_content}"

    res.status = 200
    res.content = "<h1>こんにちは</h1>おはよーおはよー"
    res.send_response
  end
end

EventMachine::run do
  EventMachine::defer do
    loop do
      puts "--"+Time.now.to_s
      sleep 1
    end
  end

  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "http server start, prot 8080"
end
