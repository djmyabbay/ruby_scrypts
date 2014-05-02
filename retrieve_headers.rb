#!/usr/local/bin/ruby

# extract code and name of genes from *.fa and save them as *.fa.hdr

headers = File.open(ARGV[0]+".hdr", "w")
File.foreach(ARGV[0]) do |line|
	if line.match(/^>/) && !line.match(/^>QUERY/) then
		line[">"] = ""
		id = line.split("\t")[0]
		name = line.split("\t")[2].split("; ")[1]
		headers.puts "#{id}\t#{name}"
	end
end
headers.close
