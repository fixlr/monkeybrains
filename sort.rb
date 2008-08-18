#!/usr/bin/env ruby
require 'rubygems'
require 'fastercsv'

if ARGV[0]
  if File.exist? ARGV[0]
    file_to_sort = ARGV[0]
  else
    puts "ERROR File not found:  #{ARGV[0]}"
    exit 1
  end
else
  puts "Usage:  ruby $0 filename"
  exit 1
end

lines = FasterCSV.read(file_to_sort, {:col_sep => "\t"})
lines.sort_by {|line| line[1].to_i }.each {|line| puts line.inspect }