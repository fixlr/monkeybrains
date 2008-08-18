#!/usr/bin/env ruby
#

require 'yaml'
require 'rubygems'
require 'fastercsv'

if ARGV.size == 2
  force_key, source_file = ARGV[0], ARGV[1]
else
  raise "Invalid parameters:  Try 'ruby #{$0} ModelX filename.csv'"
end

forces = nil
File.open(File.dirname(__FILE__) + '/muscle_forces.yml') do |f|
  YAML::load(f).each do |k, v|
    forces = v if (k == force_key)
  end
end

raise "#{force_key} not found in muscle_forces.yml" if forces.nil?

results = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
lines = FasterCSV.read(source_file, {:col_sep => "\t"})
lines.each do |l|
  if l[0] and l[1]
    force_index = l[1].to_i - 1
    results[force_index] += (l[0].to_f * forces[force_index])/2 if forces[force_index]
  end
end

0.upto(7) {|x| puts "#{x+1}: #{results[x]}"}