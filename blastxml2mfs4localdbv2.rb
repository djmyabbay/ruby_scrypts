

###for each array strings "localdbhit[]" between"<Hit_def>" and "</Hit_def>" 

file.readlines(arg[0]) do |line|
 n=0
if line =="<Hit-def>"*"</Hit-def>"
localdb[n]=line-"<Hit-def>"-"</Hit-def>"
 n=n+1
else
end



###search every .fasta file in localdb folder and find the match array strings"sequnce[]"
file.readlines(/nshare3/yabbay/localdb/*.fasta) do |line|
 n=0
 line==">"+localdb[n]
 sequence[n]=line.nextline
 n=n+1
 else 
end




###cat ">" "each localdbhit[]" "   Localdb  Localdb; Localdb; Localdb; Localdb; Localdb." "/n" into "#{ARGV[0]}.mfs"  as title of each hit
###cat "sequence[]" into "#{ARGV[0]}.mfs" as sequence of each hit


(localdb[],sequence[]).each {x,y|cat ">"+"$x"+"\sLocaldb\sLocaldb;\sLocaldb;\sLocaldb;\sLocaldb;\sLocaldb"+"\n"+"$y"+"\n" >> $input.mfs}