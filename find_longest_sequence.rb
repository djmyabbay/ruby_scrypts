#!/usr/local/bin/ruby
require 'bio'

regex_seq = /^[A-Z\-]+$/
regex_seq_char = /[A-Z]/

aln_file = open(ARGV[0])

max_seq_length = 0
longest_line= ""

while line = aln_file.gets do 
	seq = line.split()[1]
	if (seq =~ regex_seq)
		seq_length = (seq.chars.count {|x| x =~ regex_seq_char}) 
		if seq_length > max_seq_length
			max_seq_length = seq_length
			longest_line = line
		end
	end
end

# print longest_line

longest_line_id = longest_line.split(/[ |\|]/)[0]
fasta_file = Bio::FlatFile.auto(ARGV[1])
longest_entry = String.new
fasta_file.each_entry do |e|
	if e.entry_id == longest_line_id
		longest_entry = e.to_s
		break
	end
end

print longest_entry
