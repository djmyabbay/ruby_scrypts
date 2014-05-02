#!/usr/local/bin/ruby
#$ -S /usr/local/bin/ruby
#$ -cwd
#
# 071130 prepared
# 090512 updated for SupCom (ver 2.1)

require 'bio'
require 'rubygems'

class Bio::Alignment::OriginalAlignment
  def alignment_trim(cutoff)
    temp = self.alignment_slice(0,0)
    len = self.alignment_length
    (0...len).each do |pos|
      num_otu = self.alignment_site(pos).length
      num_gap = self.alignment_site(pos).reject { |y| 
        y =~ /[A-Za-z]/
      }.length
      if 1.0 * num_gap / num_otu <= cutoff
        temp.alignment_concat(self.alignment_slice(pos,1))
      end
    end
    temp
  end
end

aligned = Bio::Alignment::MultiFastaFormat.new(open(ARGV[0]).read).alignment

#result = factory.query(a)
#aligned = result.alignment

#out_untrimmed_file = File.open("#{ARGF.filename}.untrimmed.clustal",'w')
#out_untrimmed_file.puts aligned.output_clustal
#out_untrimmed_file.close


aligned2 = aligned.alignment_trim(0.7)
aligned3 = aligned2.dup

aligned3.alignment_collect do |otu| 
	gap_each_seq = 1.0 * otu.gsub(/[A-Za-z]/,'').length / otu.length
	if gap_each_seq >= 0.3
		aligned3.remove_seq(otu) if (aligned3.index(otu) !~ /^QUERY/)&&(aligned3.index(otu) !~ /Lotharella/)
	end
end

aligned4 = aligned3.alignment_trim(0.7)
#aligned4 = aligned3.alignment_trim(0.15)
aligned5 = aligned4.dup

aligned5.alignment_collect do |otu2|
        gap_each_seq2 = 1.0 * otu2.gsub(/[A-Za-z]/,'').length / otu2.length
        if gap_each_seq2 >= 0.3
                aligned5.remove_seq(otu2) if (aligned5.index(otu2) !~ /^QUERY/)&&(aligned5.index(otu2) !~ /Lotharella/)
        end
end

puts aligned5.output_clustal
