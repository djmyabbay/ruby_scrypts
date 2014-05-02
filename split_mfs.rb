#!/usr/local/bin/ruby
# 120429
# Usage: ruby split_mfs.rb FILE LIMIT
require 'bio'
require 'fileutils'

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[0])
i = 0
filenum = 0
limit = ARGV[1].to_i
file = File.open("#{ARGV[0].split(".")[0]}_#{filenum}.mfs", 'w')
ff.each_entry do |f|
	def_line = f.definition.split(/\s|\t/)[0]
	file.puts f.aaseq.to_fasta(def_line, 70)
	i = i + 1
	if (i == limit) then
		i = 0
		filenum = filenum + 1
		file.close
		file = File.open("#{ARGV[0].split(".")[0]}_#{filenum}.mfs", 'w')
	end
end
file.close
ff.close
