#!/usr/local/bin/ruby

THRESHOLD = 0.8

def find_subtree_boundary(tree, idx, direction)
	balance, i = 0, idx
	step, boundary = 	if direction == :backward then [-1, "("]
						else [1, ")"]
						end
	until (balance == 0)&&(tree[i] == boundary) do
		if tree[i] == ")" then balance += 1
		elsif tree[i] == "(" then balance -= 1
		end
		i += step
	end
	
	i-step
end

def find_subtree(tree, query)
	query_idx = tree.index(query)
	return nil unless query_idx
	subtree_begin = find_subtree_boundary(tree, query_idx, :backward)
	subtree_end = find_subtree_boundary(tree, query_idx, :forward)
	tree[subtree_begin..subtree_end]
end


def find_class(tree)
	subtree = find_subtree(tree, "QUERY")
	if !subtree then
		return "unknown"
	else
		otus = subtree.split(/[,\(\)\s]/) - [""]
		$stderr.puts otus.to_s
		id_name_map = {}
		File.foreach(ARGV[1]) do |line|
			id_name_map[line.split[0]] = line.split[1]
		end
		$stderr.puts id_name_map.to_s
		count = {}
		otus.each do |x|
			next if x.match(/QUERY/)
			if count[id_name_map[x]] then
				count[id_name_map[x]] += 1
			else
				count[id_name_map[x]] = 1
			end
		end
		$stderr.puts count.to_s
		$stderr.puts count.values.max, otus.length, count.key(count.values.max)
		if count.values.max >= (otus.length-1) * THRESHOLD then
#			return count.key(count.values.max)
			the_class = count.key(count.values.max)
			if the_class != "Rhizaria" then
				return the_class
			else
				query_idx = tree.index("QUERY")
				subtree_begin = find_subtree_boundary(tree, query_idx, :backward)
				subtree_end = find_subtree_boundary(tree, query_idx, :forward)
				tree[(subtree_begin-1)..(subtree_end+1)] = "QUERY,"
				return find_class(tree)
			end
		else
			return "unknown"
		end
	end
end

the_tree = File.read(ARGV[0])
print find_class(the_tree)
