#!/usr/local/bin/ruby
# 120910
# written by Shinichiro Maruyama, maruyama@dal.ca
require 'bio'

ff = Bio::FlatFile.open(Bio::FastaFormat, ARGV[0])
ff.each_entry do |f|

  if f.definition =~ /CMER/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] + "\t" +
"Cyanidioschyzon merolae	Eukaryota; Rhodophyta; Bangiophyceae; Cyanidiales; Cyanidiaceae; Cyanidioschyzon."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /gnl\|stig/
    def_line = f.definition.split(/\|/)[2].split(/[.]/)[0] + "\t" +
"Galdieria sulphuraria	Eukaryota; Rhodophyta; Bangiophyceae; Cyanidiales; Cyanidiaceae; Galdieria."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Euglena/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] + "\t" +
"Euglena gracilis	Eukaryota; Euglenozoa; Euglenida; Euglenales; Euglena."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Peranema/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] + "\t" +
"Peranema trichophorum	Eukaryota; Euglenozoa; Euglenida; Heteronematales; Heteronematidae; Peranema."
    puts f.aaseq.to_fasta(def_line, 70)
    
    
  elsif f.definition =~ /Auran1/
    def_line = f.definition.split(/\|/)[1] + "\t" +
"Aureococcus anophagefferens	Eukaryota; stramenopiles; Pelagophyceae; Aureococcus."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Emihu1/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] + "\t" +
"Emiliania huxleyi	Eukaryota; Haptophyceae; Isochrysidales; Noelaerhabdaceae; Emiliania."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Bigna1/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] +"\t" +
"Bigelowiella natans	Eukaryota; Rhizaria; Cercozoa; Chlorarachniophyceae; Bigelowiella; Bigelowiella."
    puts f.aaseq.to_fasta(def_line, 70)
    
  elsif f.definition =~ /Guith1/
    def_line = f.definition.split(/\|/)[2].split(/ /)[0] + "\t" +
"Guillardia theta	Eukaryota; Cryptophyta; Pyrenomonadales; Geminigeraceae; Guillardia."
    puts f.aaseq.to_fasta(def_line, 70)
    
    
  elsif f.definition =~ /Calliarthron_tuberculosum/
    def_line = f.definition.split(/\t/)[0].sub(/LocalDB_Plantae-Rhodophyta-Calliarthron_tuberculosum_/,"") + "\t" +
"Calliarthron tuberculosum	Eukaryota; Rhodophyta; Florideophyceae; Corallinales; Corallinaceae; Corallinoideae; Calliarthron."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Lth_Amo/
    def_line = f.definition.split(/\|/)[2].split(/[.]/)[0] + "\t" +
"Lotharella amoeboformis	Eukaryota; Rhizaria; Cercozoa; Chlorarachniophyceae; Lotharella; Lotharella."
    puts f.aaseq.to_fasta(def_line, 70)

  elsif f.definition =~ /Porphyridium_cruentum/
    def_line = f.definition.split(/\t/)[0].sub(/LocalDB_Plantae-Rhodophyta-Porphyridium_cruentum_/,"") + "\t" +
"Porphyridium cruentum	Eukaryota; Rhodophyta; Bangiophyceae; Porphyridiales; Porphyridiaceae; Porphyridium."
    puts f.aaseq.to_fasta(def_line, 70)
    
  else
    puts f.aaseq.to_fasta(f.definition, 70)
  end
end

