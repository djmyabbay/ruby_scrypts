#!/usr/local/bin/ruby
# prepared 080531
# updated 110721 (ver 5.0) for SGE@hgc.jp

require 'bio'
require 'tempfile'

#
# Extract a comment line from ARGV[0] (mfs.fa made by netblastout_mfs.rb)
# and prepare a hash comprised of accession, taxon name and species name
#

array = Array::new
taxon_hash = Hash::new

input_fasta = open(ARGV[0])
while text = input_fasta.gets do
  if text  =~ /^>/
    array = text.sub(/>/, '').split(/\t/)
    taxon_hash.store(array[0], array)
  end
end
input_fasta.close

#
# Replace OTU name with taxonomy name in a Newick format 
# tree file designated as ARGV[1]
#

temp = Tempfile::new("tmp", "./")
query_name = String::new
if ARGV[2] == nil
  search_query = "QUERY"
else
  search_query = "#{ARGV[2]}"
end

input_newick = open(ARGV[1])
while line = input_newick.gets do
  line.chomp!
  line_array = line.split(/([,:;\(\)])/)
  line_array.each do |orig_str|
    str = orig_str.gsub(/ /,"_") 
    if str =~ /#{search_query}/
      query_name = str
      temp.print str

# <<MEMO>>
# The first 'word' of the string "otu_label" is
# used to define a query for the next trimming process.  

    elsif str =~ /CM[A-Z0-9]+C/
      taxon_hash.keys.each do |key|
        if key =~ /^#{str}/
          otu_label = String::new 
          otu_label =
          taxon_hash[key][1].gsub(/[:;',()]/,"") +
          "\t" +
          taxon_hash[key][0] +
          "\t" +
          taxon_hash[key][2].split('; ')[1].gsub(/[', ()]/,"")
          
          temp.print otu_label
        end
      end

    elsif str =~ /[A-z]+\d+_?[A-z0-9]?_+\d+/
      taxon_hash.keys.each do |key|
        if key =~ /^#{str}/
          otu_label = String::new 
          otu_label =
          taxon_hash[key][1].gsub(/[:;',()]/,"") +
          "\t" +
          taxon_hash[key][0] +
          "\t" +
          taxon_hash[key][2].split('; ')[1].gsub(/[', ()]/,"")
          
          temp.print otu_label
        end
      end

    elsif str =~ /[A-z]+_?\d+/
      taxon_hash.keys.each do |key|
        if key =~ /^#{str}/
          otu_label = String::new 
          if taxon_hash[key][2] =~ /Bacteria|Archaea/
            if taxon_hash[key][2] =~ /Cyanobacteria/         
              otu_label =
              taxon_hash[key][2].split('; ')[2] +
              "\s\t" +
              taxon_hash[key][0]       
            else
              otu_label =
              taxon_hash[key][2].split('; ')[0] +
              "\s\t" +
              taxon_hash[key][0]         
            end
          else
            if taxon_hash[key][2] =~ /Metazoa/                     
              otu_label =
              taxon_hash[key][2].split('; ')[2] +
              "\s\t" +
              taxon_hash[key][0]
            elsif taxon_hash[key][2] =~ /Fungi/
              otu_label =
              taxon_hash[key][2].split('; ')[3] +
              "\s\t" +
              taxon_hash[key][0]
            elsif taxon_hash[key][2] =~ /Spermatophyta/
              otu_label =
              taxon_hash[key][2].split('; ')[5] +
              "\s\t" +
              taxon_hash[key][0]
            else
              otu_label =
              taxon_hash[key][1].gsub(/[:;',()]/,"") +
              "\t" +
              taxon_hash[key][0]
            end
          end
          
          temp.print otu_label
        end
      end

    else
      temp.print str
    end
  end
end

input_newick.close
temp.close

#
# Trim redundant OTU with the same taxonomy name and 
# output tree as a Newick format tree file
#

temp.open
tree = Bio::Newick.new(temp.read).tree
7.times {
tree.each_node do |x|
  unless tree.leaves(x) == nil
    array = Array.new
    tree.leaves(x).join(',').split(/,/).each do |y|
      array.push y.split(/ /)[0]
    end
    if array.size > 1
      if array.uniq.size == 1
        tree.remove_node(tree.leaves(x).pop)
        tree.remove_nonsense_nodes
      end
    end
  end
end
}

#
# List up the trimmed OTU with refseq_ID 
#

#p tree.leaves
tree.leaves.join(',').split(/,/).uniq.each do |ee|
  if ee =~ /#{search_query}/
    puts ee.gsub(/ /,'_')
  else
    puts ee.split(/\t/)[1].gsub(/ /,'_')
	#    puts ee.split(/\t/)[1]
  end
end

temp.close(true)



