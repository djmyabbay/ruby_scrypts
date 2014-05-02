#!/usr/bin/ruby

file = File.open(ARGV[0])
count = 0
file.each do |line|
	count = count + 1 if line.start_with?(">")
end
file.rewind
i = 1
length = count.to_s.length
format = "%0" + length.to_s + "d"
file_output = File.open(ARGV[1], "w")
file.each do |line|
	if line.start_with?(">")
		line.insert(1, format % i)
		i = i + 1
	end
	file_output.print line
end
file_output.close
file.close
