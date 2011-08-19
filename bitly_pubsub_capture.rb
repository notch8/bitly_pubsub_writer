#!/usr/bin/env ruby
require 'net/http'

API_KEY = PUT_BITLY_API_KEY_AS_STRING_HERE 

def start_time_and_file
  if @file
    @file.close
  end
  @start_time = Time.now
  @file_name = @file_prefix + @start_time.strftime("%Y-%m-%d-#{@start_time.to_i}")
  @file = File.open(@file_name, "w")
end

@file_prefix = "/var/www/measured_voice/current/public/system/usa_bitly/usagov_bitly_data"
start_time_and_file

Net::HTTP.get_response(URI.parse("http://pubsub.bitly.net/pro/decodes?login=usagov&apiKey=#{API_KEY}")) do |response|
 response.read_body do |segment|
   if @start_time < (Time.now - 3600) #more than an hour
     start_time_and_file
   end
   @file.puts segment
 end
end
