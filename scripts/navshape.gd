extends NavigationPolygonInstance

export (PoolVector2Array) var navigation_shape = PoolVector2Array()


func _ready():
	var worldnav = get_node("/root/main/Nav/WorldNav")
	for i in range(navpoly.get_outline_count()):
		var outline = PoolVector2Array()
		for v in navpoly.get_outline(i):
			outline.push_back(worldnav.to_local(to_global(v)))
		worldnav.add_shape(outline)
	
	worldnav.update()
	


