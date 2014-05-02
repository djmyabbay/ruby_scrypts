#!/usr/local/bin/ruby
# 110720
require 'bio'
require 'fileutils'

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[0])
ff.each_entry do |f|
  each_file = File.open("#{f.definition.split(/\s|\t/)[0]}.ps.blast", 'a')
  def_line = "QUERY_" + f.definition.split(/\s|\t/)[0]
  each_file.puts f.aaseq.to_fasta(def_line, 70)
  each_file.close
end
