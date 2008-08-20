#!/usr/bin/env ruby
#

require 'yaml'
require 'rubygems'
require 'fastercsv'

class Float
  def mbformat
  	"%.2e" % self
  end
end

class Forces
  attr_reader :strain, :results
  
  def initialize(force_key)
    @source_path = File.join(File.dirname(__FILE__), force_key)
    @forces = muscle_forces(force_key)
    @results = {}
    @strain = []
    @forces.each do |k,v|
      @results[k] = calculate(k)
      @results[k].each_index {|i| @strain[i] = @strain[i] ? @strain[i] + (@results[k][i]/2) : (@results[k][i]/2) }
    end
  end
  
  def muscle_forces(fk)
    forces = nil
    File.open(File.join(File.dirname(__FILE__), 'muscle_forces.yml')) do |f|
      YAML::load(f).each do |k, v|
        forces = v if (k == fk)
      end
    end
    raise "#{fk} not found in muscle_forces.yml" if forces.nil?

    return forces
  end
  
  def calculate(node)
    results = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    lines = FasterCSV.read(File.join(@source_path, node), {:col_sep => "\t"})
    lines.each do |l|
      if l[0] and l[1]
        force_index = l[1].to_i - 1
        results[force_index] += (l[0].to_f * @forces[node][force_index]) if @forces[node][force_index]
      end
    end
    results
  end

  def report
    0.upto(7) {|x| puts "#{x+1}\t#{@strain[x].mbformat}"}
    puts "Sum\t#{@strain[0..7].inject {|sum,x| sum ? sum+x : x}.mbformat}"
  end
end    

if ARGV.size == 1
  force_key = ARGV[0]
else
  raise "Invalid parameters:  Try 'ruby #{$0} ModelX'"
end

f = Forces.new(force_key)
f.report