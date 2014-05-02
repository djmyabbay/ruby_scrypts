#!/usr/local/bin/ruby

print("no.,gene-code,gene,affiliation,root,root-affiliation,OTU_num,C_num,R_num,G_num\n")
queries = Array::new
File.open(ARGV[0]) do |f|
	queries = f.read.split(">")
end
beginning = 1
count = 0
#File.open("beginning") do |f|
#	beginning = f.read.to_i
#end
File.open("queries_count") do |f|
	count = f.read.to_i
end
beginning.upto(beginning + count - 1) do |i|
	begin
		gene_code, gene = queries[i].split("\n")[0].split(" ", 2)
		gene.chomp!
		affil_file = `ls #{i}/*.affil`.chomp
		root_file = `ls #{i}/*.newroot`.chomp
		# if !(File.size?(affil_file) && File.size?(root_file)) then
		# 	print("#{i}\t#{gene_code}\t#{gene}\tERROR!\n")
		# 	next
		# end
		fasta_file = `ls #{i}/*.fas`.chomp
		affiliation = open(affil_file).read.chomp
		root, root_affiliation = open(root_file).read.split("\n")[0].split("\t")[1..2]
		root_affiliation = root_affiliation.split("; ")[1]
		OTU_num = open(fasta_file).read.scan(/>/).count
		C_num = open(fasta_file).read.scan(/Cyanobacteria/).count
 	       R_num = open(fasta_file).read.scan(/Rhodophyta/).count
	       G_num = open(fasta_file).read.scan(/Viridiplantae/).count
		print("\n#{i},#{gene_code},#{gene},#{affiliation},#{root},#{root_affiliation},#{OTU_num},#{C_num},#{R_num},#{G_num}")
	rescue Exception => e
		print("\n#{i},ERROR!!")
	end
end