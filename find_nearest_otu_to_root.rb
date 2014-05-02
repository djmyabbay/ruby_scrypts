#!/usr/local/bin/ruby

require 'bio'
ID_REGEX = /[A-Z]{2}_[0-9]+/

tree_filename = ARGV[0]
root_filename = ARGV[1]

tree = Bio::Newick.new(open(tree_filename).read).tree
# root = open(root_filename).read.split()[0]
root_str = open(root_filename).read
root_id = root_str[ID_REGEX]
root_id["_"] = " "
# $stderr.puts root_id
# nearest_otu_to_root = tree.each_node.min_by{|n| tree.distance(n, tree.get_node_by_name(root))}
#root_node = nil
# tree.each_node do |n|
# 	# $stderr.puts tree.get_node_name(n)
# 	if tree.get_node_name(n) && tree.get_node_name(n)[root_id] then
# 		root_node = n
# 		break
# 	end
# end
root_node = tree.get_node_by_name(root_id)
raise "root_node is nil!" if !root_node
# $stderr.puts root_node.inspect

min_d = 1.0/0.0
nearest_otu_to_root = nil
tree.each_node do |n|
	next if (n == root_node || !tree.leaves(n).empty?)
	d = tree.distance(n, root_node)
	# $stderr.print "#{n}\t#{d}\n"
	if d > 1e-3 && d<min_d then
		min_d = d
		nearest_otu_to_root = n
	end
end

# $stderr.puts nearest_otu_to_root.inspect

# print (tree.get_node_name(nearest_otu_to_root))
newroot = tree.get_node_name(nearest_otu_to_root).sub!(" ", "_")

matching = 0
newroot_full = ""
File.open(ARGV[2]).lines do |line|
	if matching == 0 then
		if line.include?(newroot) then
			matching = 1
			newroot_full += line
		end
	else
		if line =~ ID_REGEX then
			break
		else
			newroot_full += line
		end
	end
end

print newroot_full
