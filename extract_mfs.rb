#!/usr/local/bin/ruby
# 080124
# 081208����
# trim_mfs.rb������
# list_file�Ŏw�肳�ꂽ�G���g���[���}���`�t�@�X�^���璊�o����

require 'bio'

list_array = Array::new
list_file = open(ARGV[0])
while line = list_file.gets do
  list_array.push(line.chomp.gsub(/[\|.]/,""))
end
list_file.close

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[1])
ff.each_entry do |f|
  list_array.each do |e|
    if f.definition.gsub(/[\|.]/,"") =~ /#{e}/
      puts f.aaseq.to_fasta(f.definition, 60)
    end
  end
end
