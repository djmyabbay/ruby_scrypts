#!/usr/local/bin/ruby
# 090428

file = open(ARGV[0])
puts file.read.gsub(/\(/,"\(\n").gsub(/\)/,"\)\n").gsub(/[,]/,"\,\n")
file.close
