#!/usr/bin/env ruby
# This script reads in the contents of a tab-delimited CSV and outputs
# the mean of the FIRST column only.
require 'csv'

# First let's modify the generic Array class to add sum and mean methods
class Array
  # Sum is self-explanatory 
  def sum
    inject(nil){|sum,x| sum ? sum+x : x}
  end
  
  # Mean is sum divided by the size of the array
  def mean
    sum / size
  end
end

# Return the list of CSV files in the given directory
def find_files(path)
  Dir.entries(path).reject {|f| f =~ /^\./} || Array.new
end

if ARGV[0]
  if File.directory?(ARGV[0])
    files = find_files(ARGV[0]).collect {|f| File.join(ARGV[0], f)}
    summary = true
  elsif File.file?(ARGV[0])
    files = [ARGV[0]]
  end
else
  files = find_files(File.dirname(__FILE__))
  summary = true
end

# Initialize a new array that we will temporarily store
# the first column in.
files.each do |file_path|
  column = Array.new
  CSV.open(file_path, "r", "\t").each do |line|
    column << line[0].to_f unless line[0].nil?
  end
  print "#{file_path}:  " if summary
  puts "%.2e" % column.mean
end
