#!/usr/local/bin/ruby

require 'rexml/document'
require 'bio'

file = File.open(ARGV[0])
doc = REXML::Document.new file
defs = Array::new
doc.elements.each("BlastOutput/BlastOutput_iterations/Iteration/Iteration_hits/Hit/Hit_def") { |element| defs.push(element.text) }
file.close
# p defs
localdb = nil
Dir.chdir("/home/yabbay/localdb") { localdb = Dir.glob("*.fasta") }
File.open(ARGV[1], "w") do |output|
	localdb.each do |db|
		Bio::FlatFile.auto("/home/yabbay/localdb/" + db).each_entry do |seq|
				defs.each do |the_def|
					if the_def.start_with?(seq.entry_id)
						output.puts(">" + "LocalDB_" + seq.definition + "\t" + seq.definition + "\t" + db.split(".")[0] + "_Localdb; Localdb; Localdb; Localdb.")
						output.puts(seq.seq)
					end
				end
		end
	end
end
