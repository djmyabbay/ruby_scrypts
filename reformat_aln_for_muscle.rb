#!/usr/local/bin/ruby

File.open(ARGV[0]) do |f|
	f.each do |line|
		print ">"
		line.split.each {|x| puts x}
	end
end
