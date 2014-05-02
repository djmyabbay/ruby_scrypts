#!/usr/local/bin/ruby

require 'bio'

DELIMITER = "\t"
AFFIL_HIERACHY = 1
IDX_AFFIL = 1
$tree = Bio::Newick.new(open(ARGV[1]).read).tree
$blast_fasta = Hash::new

def extract_affiliation(affil_hierachy)
	return affil_hierachy.split("; ")[IDX_AFFIL]
end

def get_leaf_affiliation(leaf)
	id = $tree.get_node_name(leaf)
	if id.include?" " then
		id = id.sub!(" ", "_")
	end
	return extract_affiliation(($blast_fasta[id].split(DELIMITER))[AFFIL_HIERACHY])
end

def proportions_of_affiliations(subtree_root)
	children = $tree.children(subtree_root)
	children_count = children.length
	if children_count == 0
		return { get_leaf_affiliation(subtree_root) => 1.0 }
	else
		children_affil_prop = children.map{|child| proportions_of_affiliations(child)}
		merged = Hash::new
		children_affil_prop.each do |hash|
			hash.each{|affil, prop| hash[affil] = prop / children_count}
			merged.merge!(hash) {|key, v1, v2| v1+v2}
		end
		return merged
	end
end
		
	
blast_fasta_file = open(ARGV[0])
while (line = blast_fasta_file.gets) do
	id, otu = line.split(DELIMITER, 2)
	id.sub!(">", "")
	$blast_fasta[id] = otu
end
# query = $tree.get_node_by_name(($tree.leaves.map{|n| $tree.get_node_name(n)}.select{|i| i["QUERY"]})[0])
query_name = ($tree.leaves.map{|n| $tree.get_node_name(n)}.select{|i| i.include?("QUERY")})[0]
if !query_name then
	print("unknown")
	exit
end
query = $tree.get_node_by_name(query_name)
sibling_of_query = ($tree.children($tree.parent(query))).select{|n| n != query}[0]

affiliation_candidates_of_query = Hash::new
affiliation_candidates_of_query = proportions_of_affiliations(sibling_of_query)
most_significant_candidate = affiliation_candidates_of_query.select{|affil, prop| prop > 0.5}

if most_significant_candidate.empty?
	print("unknown")
else
	print((most_significant_candidate.keys)[0])
end
print("\n")
