#!/usr/local/bin/ruby
# 071204
# Modify font information in tree_file.ps
# Last updated at 090415 (ver. 7.0)

#
# Extract a comment line from ARGV[0] (mfs.fa made by netblastout_mfs.rb)
# and prepare a hash comprised of accession, taxon name and species name
#

# array = Array::new
taxon_hash = Array::new

mfs_file = open(ARGV[0])
while text = mfs_file.gets do
  if text  =~ /^>/
    array = text.sub(/>/, '')
    # taxon_hash.store(array[0], array)
    taxon_hash << array
  end
end
mfs_file.close

#
# Extract OTU number and site number from aln.phy designated as ARGV[1]
#

phylip_file = open(ARGV[1])
phylip_array = phylip_file.gets.split(/\s+/)
unless phylip_array[0] =~ /\d/
  phylip_array.shift
end
phylip_info = ' [' + phylip_array[0] + ' taxa ' + ']'
phylip_file.close

#
# Change font color and size of OTU names in tree.ps designated as ARGV[2]
#

str = <<EOS
/basefont /Times-Roman findfont 8 scalefont def
/smallfont /Times-Roman findfont 6 scalefont def
/mediumfont /Times-Roman findfont 10 scalefont def
/largefont /Times-Roman findfont 14 scalefont def
EOS
color_red = 'mediumfont setfont 0.8 0.0 0.8 setrgbcolor ('
color_green = 'mediumfont setfont 0.0 0.7 0.0 setrgbcolor ('
color_blue = 'mediumfont setfont 0.0 0.3 1.0 setrgbcolor ('
color_bluegreen = 'mediumfont setfont 0.0 0.5 0.5 setrgbcolor ('
color_purple = 'mediumfont setfont 0.4 0.0 0.4 setrgbcolor ('
color_orange = 'largefont setfont 1.0 0.2 0.2 setrgbcolor ('
color_brown = 'smallfont setfont 0.5 0.2 0.0 setrgbcolor ('
base_gray = ') show 0 setgray basefont setfont'

file = open(ARGV[2])
while line = file.gets
  case line
  when /^\/basefont/
    puts str
  when /.phb/
    puts line.chomp + phylip_info
  when /show$/
    access = line.gsub(/\(|\)/, '').split(/ /)[0]
    if access =~ /QUERY_/
      puts color_orange + access + base_gray

# Accession number (RefSeq etc.)
    elsif access =~ /[A-Za-z]+/
      header = taxon_hash.select{|v| v.include?(access)}[0]
      if header =~ /Eukaryota/
      # if taxon_hash[access][2] =~ /Eukaryota/
        # case taxon_hash[access][2]
	case header
        when /Green/
          puts color_green +' '+ access + base_gray
        when /Red/
          puts color_red + ' '+ access + base_gray
        when /Bigelowiella/
          puts color_yellow + ' '+ access + base_gray
        when /Glauco/
          puts color_bluegreen +' '+ access + base_gray
        when /Metazoa/
          puts '(' +' '+ access + ') show'
        when /Fungi/
          puts '(' +' '+ access + ') show'
        when /Acanthamoebidae/
          puts '(' +' '+ access + ') show'
        when /Entamoebidae/
          puts '(' +' '+ access + ') show'
        when /Lobosea/
          puts '(' +' '+ access + ') show'
        when /Mycetozoa/
          puts '(' +' '+ access + ') show'
        else
          puts color_purple +' '+ access + base_gray
        end     
      else
        if header =~ /Cyano-/
          puts color_blue +' '+ access + base_gray
        elsif header =~ /Green/
          puts color_green +' '+ access + base_gray
        elsif header =~ /Red/
          puts color_red +' '+ access + base_gray
        elsif header =~ /Bigelow/
          puts color_brown +' '+ access + base_gray
        elsif header =~ /Chlamydiae/
          puts color_brown +' '+ access + base_gray
        else
#         Other Bacteria (not Cyano, Chlamydiae)
          puts 'smallfont setfont (' +' '+ access + ') show basefont setfont' 
        end
      end
    else
      puts line
    end
  else
    puts line
  end
end
file.close