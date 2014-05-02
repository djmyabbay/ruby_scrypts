#!/usr/local/bin/ruby

# remove percentage numbers in *.aln.phb and save it as *.aln.phb.abr

abr_tree = File.open(ARGV[0]+".abr", "w")
File.foreach(ARGV[0]) do |line|
	abr_tree << line.gsub(/:\d\.\d+|^\d+:\d\.\d+/, "")
end

abr_tree.close()
