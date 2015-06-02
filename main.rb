#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require "open-uri"
require 'active_support'
require 'active_support/core_ext' # to_query support
#require 'byebug'

if ARGV.length == 0
  puts """At least one keyword should be given.
Example: ./main.rb cat dog anime:200
Exit now."""
  abort # An unsuccessful exit.
end

ARGV.each_with_index do |original_keyword, i|
  log_suffix = "[#{i+1}/#{ARGV.length}] "
  puts log_suffix + "Now searching keyword: #{original_keyword}"

  # Parse argv.
  if original_keyword.include? ":"
    keyword, limit = original_keyword.split(":")
  else
    keyword = original_keyword
    limit = 25
  end

  # Load offset from file.
  offset_file = "./incoming/#{keyword}/.offset"
  offset = 0
  offset = File.new(offset_file, "r").gets.to_i if File.exists?(offset_file)

  # Init local directory.
  directory = "./incoming/#{keyword}/"
  system 'mkdir', '-p', directory
  keyword.gsub! "+", " " # for to_query

  # WARNING: using public API key in this case, should be replaced with your own.
  query ={ api_key: "dc6zaTOxFJmzC" , q: keyword.strip, limit: limit, offset: offset }
  search_url = "http://api.giphy.com/v1/gifs/search?" + query.to_query
  puts log_suffix + "Search URL: #{search_url}"

  # Get list.
  res = JSON.parse(open(search_url).read)["data"]
  res = res.map do |r|
    {url: r["images"]["original"]["url"], filename: r["id"] + ".gif"}
  end


  # Download.
  res.each_with_index do |target, j|
    if File.exists?(directory + target[:filename])
      puts log_suffix + "[#{j+1}/#{res.length}] #{target[:filename]} exists. Skipped."
      next
    end
    print log_suffix + "[#{j+1}/#{res.length}] Now downloading #{directory + target[:filename]} ...... "
    open(target[:url]) do |f|
      File.open(directory + target[:filename], "wb") do |file|
        file.puts f.read
      end
    end
    print "DONE.\n"
  end

  # Write offset count into .offset file.
  File.open(offset_file, "w") { |file| file.puts offset + limit }

  puts log_suffix + "Keyword #{keyword} finished.\n"

end

puts "\n\nALL DONE. ENJOY!!!"
exit
