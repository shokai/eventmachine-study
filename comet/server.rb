#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

port = 8080
port = ARGV.shift.to_i if ARGV.size > 0

@@comet_timeout = 60
@@comet_timeout = ARGV.shift.to_i if ARGV.size > 0

@@data = Hash.new
class CometKvs < EventMachine::Connection
  include EventMachine::HttpServer
  
  def process_http_request
    res = EventMachine::DelegatedHttpResponse.new(self)
    
    puts "request_method : #{@http_request_method}"
    puts "path_info : #{@http_path_info}"
    puts "query_str : #{@http_query_string}"
    puts "post_content : #{@http_post_content}"
    key = @http_path_info
    if @http_request_method == 'POST'
      puts value = @http_post_content
      @@data[key] = value
      res.status = 200
      res.content = value
      res.send_response
    elsif @http_request_method == 'GET'
      EM::defer do 
        @@comet_timeout.times do ## keep connection 60 sec
          break if value = @@data[key]
          sleep 1
        end
        if value
          @@data[key] = nil
          res.status = 200
          res.content = value
          res.send_response
        else
          res.status = 404
          res.content = ''
          res.send_response
        end
      end
    end
  end
end

EventMachine::run do
  EventMachine::start_server("0.0.0.0", port, CometKvs)
  puts "http server start, port:#{port}, comet_timeout:#{@@comet_timeout}(sec)"
end
