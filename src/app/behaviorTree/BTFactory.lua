local BTFactory = {}

function BTFactory.createTree( agent, name )
	local tree = game.BTTree:create(agent)
	tree:load(name)
	return tree
end

function BTFactory.createNode( tree, id, agent )
	assert(tree and tree[id], string.format("id:%s not exist in tree:%s", id, tree))
	-- print("asdasdasd ", agent, tree[id].name)
	local node = game[tree[id].name]:create(agent)
	node:load(tree, id)
	return node
end

return BTFactory