#!/usr/local/bin/ruby

regex_seq = /^[A-Z\-]+$/
regex_seq_char = /[A-Z]/

blasted_file = open(ARGV[0])

seq_count = 0
seq_length_sum = 0.0

while line = blasted_file.gets do 
	seq = line.split()[1]
	if (seq =~ regex_seq)
		seq_length = (seq.chars.count {|x| x =~ regex_seq_char}) 
		seq_count = seq_count + 1
		seq_length_sum = seq_length_sum + seq_length
	end
end

seq_length_avg = seq_length_sum / seq_count

blasted_file.rewind

highest_evalue = 0.0
highest_evalued_otu = ""

while line = blasted_file.gets do
	seq = line.split()[1]
	if (seq =~ regex_seq) 
		seq_length = (seq.chars.count {|x| x =~ regex_seq_char})
		evalue = line.split()[2].to_f
		if (evalue > highest_evalue) && (seq_length >= seq_length_avg)
			highest_evalue = evalue
			highest_evalued_otu = line.split()[0] + "\t" + line.split()[1]
		end
	end
end
blasted_file.close

regex_seq_id = /[A-Z]{2}_[0-9]+/
seq_id = highest_evalued_otu[regex_seq_id]
matching = 0
highest_evalued_otu_full = ""
File.open(ARGV[1]).lines do |line|
	if matching == 0 then
		if line.include? seq_id then
			matching = 1
			highest_evalued_otu_full += line
		end
	else
		if line =~ regex_seq_id then
			break
		else
			highest_evalued_otu_full += line
		end
	end
end

print highest_evalued_otu_full
# print highest_evalued_otu
#print highest_evalue
