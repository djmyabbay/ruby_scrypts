#!/usr/local/bin/ruby
# 110719
require 'bio'

file = open(ARGV[0])
blastout_m7_file = Bio::FlatFile.new(Bio::Blast::Report, file)

# Parse XML output and restore as Bio::Blast::Report object

  Bio::Blast.reports(blastout_m7_file) do |report|
#    if query_hash.key?(report.query_def) 

# Extension of output fasta file should be '.ps.blast.fa',
# because the newicktops program shorten filenames at periods (.) 
# in the later stage of analysis.

      out_file = File.open("#{ARGV[0]}.mfs", 'w')
      hit_array = []
      report.each do |hit|
        hit_array.push(hit.target_id)
      end

      ncbi = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&rettype=gp&retmode=text&id="

      while hit_array.size > 0
        path = ()
        temp_array = []
        50.times do
          temp_array = temp_array.push(hit_array.shift)
        end  
        path = ncbi + temp_array.join(",")
        print ":"
        begin
          begin
            ff = Bio::FlatFile.open_uri(path)
            print "."
          rescue Timeout::Error => ex
            puts ex.class
            puts ex.message
            sleep(1)
            retry
          end  

          ff.each_entry do |gb|
#           Set 'size > 0' to prevent reading empty entry in Bio::FlatFileopen_uri object.
            if gb.aaseq.size > 0 
              definition = "#{gb.accession}\t#{gb.organism}\t#{gb.taxonomy}"
              out_file.puts gb.aaseq.to_fasta(definition, 60) 
            end
          end
          sleep(1)

        rescue => ex
          puts ex.class
          puts ex.message
          sleep(1)
          retry
        end  
      end
      out_file.close
      puts
#    end
  end
file.close
