#!/usr/local/bin/ruby
# 080422
# convert clustal-formet file into phylip file

require 'bio'
i = 0

phy = open(ARGV[0])
otu_len = phy.gets
phy.close

aln = open(ARGV[1])
while line = aln.gets do
  if line =~ /^CLUSTAL/
    puts otu_len
  elsif line.chomp.length == 0
    puts line if i > 1
    i += 1
  elsif line =~ /\w/
    if i < 3
      puts line
    else
      puts line.split(/\s+/)[1]
    end
  end
end
aln.close
