#!/usr/local/bin/ruby

while true
	puts `qstat`
	puts Time.now
	sleep ARGV[0].to_i
end
