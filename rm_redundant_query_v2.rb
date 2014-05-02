#!/usr/local/bin/ruby
# 110720
require 'bio'
first_seq = String.new

ref = Bio::FlatFile.open(Bio::FastaFormat, ARGV[0])
ref.each_entry do |e|
  puts e.aaseq.to_fasta(e.definition, 60)
  first_seq = e.aaseq.sub(/[*]/,"")
end

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[1])
ff.each_entry do |f|
  unless f.aaseq.sub(/[*]/,"") == first_seq 
    puts f.aaseq.to_fasta(f.definition, 60)
  end
end

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[2])
ff.each_entry do |f|
  unless f.aaseq.sub(/[*]/,"") == first_seq 
    puts f.aaseq.to_fasta(f.definition, 60)
  end
end