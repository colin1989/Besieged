local BTFactory = {}

function BTFactory.createTree( name )
	local tree = game.BTTree:create()
	tree:load(name)
	return tree
end

function BTFactory.createNode( tree, id )
	print(id, tree[id].name)
	local node = game[tree[id].name]:create()
	node:load(tree, id)
	return node
end

return BTFactory