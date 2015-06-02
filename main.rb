#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require "nokogiri"
require "httparty"
require 'active_support'
require 'active_support/core_ext' # to_query
require 'byebug'

if ARGV.length == 0
  puts "At least one keyword should be given.\nExample: ./main.rb cat dog anime\nExit now."
  abort
end

ARGV.each do |keyword|
  #puts keyword
  # Init
  query ={ api_key: "dc6zaTOxFJmzC" , q: keyword.strip } # Public API key, should be replaced in the future.
  search_url = "http://api.giphy.com/v1/gifs/search?"
  # Get list.
  byebug
  res = HTTParty.get(search_url + query.to_query)
  res = JSON.parse(res.body)["data"]
  res = res.map do |r|
    {url: r["images"]["original"]["url"], filename: r["id"] + ".gif"}
  end

  puts res
  exit

end
