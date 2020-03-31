extends TileMap


export var enabled = true

var outlines = []


func _ready():
	if not enabled:
		return
	var worldnav = get_node("/root/main/Nav/WorldNav")
	var ts = tile_set
	var shapes = {}
	var tssize = ts.autotile_get_size(0)
	var invscale = Vector2(1/tssize.x, 1/tssize.y)
	for sd in ts.tile_get_shapes(0):
		shapes[sd["autotile_coord"]] = sd
	for cell in get_used_cells():
		var coord = get_cell_autotile_coord(cell.x, cell.y)
		var shape = shapes[coord]["shape"].points
		var trans = Transform2D().scaled(invscale).scaled(cell_size).translated(cell * cell_size)
		var a = trans.xform(shape)
		var outline = global_transform.xform(a)
		var navshape = Geometry.offset_polygon_2d(outline, worldnav.nav_width)[0]
		outlines.append(navshape)
		worldnav.add_shape(navshape)
	update()
	worldnav.update()
