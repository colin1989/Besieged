local BTFactory = {}

function BTFactory.createTree( entity, name )
	local tree = game.BTTree:create(entity)
	tree:load(name)
	return tree
end

function BTFactory.createNode( tree, id, entity )
	assert(tree and tree[id], string.format("id:%s not exist in tree:%s", id, tree))
	-- print("asdasdasd ", entity, tree[id].name)
	local node = game[tree[id].name]:create(entity)
	node:load(tree, id)
	return node
end

return BTFactory