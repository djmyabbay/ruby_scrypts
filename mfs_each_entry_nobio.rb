#!/usr/local/bin/ruby
# 130105
require 'fileutils'

ff = File.open(ARGV[0])
each_file = nil
line = nil
ff.each_line do |f|
	if f.start_with?(">") then
		if each_file != nil then
			each_file.close
		end 
		each_file = File.open("#{f.delete(">").split[0]}.ps.blast", "w")
		line = ">QUERY_#{f.delete(">")}"
	else
		line = f
	end
	each_file.puts(line)
	end
each_file.close if each_file != nil
