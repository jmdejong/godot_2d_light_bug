extends NavigationPolygonInstance

export var nav_width = 14.9
export var min_dist = 0.4
export var min_dot = -0.99

var count = 0

func getm(vec, id):
	id = id % vec.size()
	if id < 0:
		id += vec.size()
	return vec[id]

func overlaps(a, b):
	var intersect = Geometry.intersect_polygons_2d(a, b)
	return not intersect.empty()

func merge_overlapping(a, b):
	var union = Geometry.merge_polygons_2d(a, b)
	for poly in union:
		if not Geometry.is_polygon_clockwise(poly):
			poly.invert()
			return poly
	assert(false)

func add_shape(outline):
	var i=1
	while i < navpoly.get_outline_count():
		var other = navpoly.get_outline(i)
		if overlaps(outline, other):
			outline = merge_overlapping(outline, other)
			navpoly.remove_outline(i)
		else:
			i += 1
	var j = 0
	while j < outline.size():
		var a = getm(outline, j-1)
		var b = outline[j]
		var c = getm(outline, j+1)
		if a.distance_to(b) < min_dist or b.distance_to(c) < min_dist:
			outline.remove(j)
			continue
		var x = (a - b).normalized()
		var y = (c - b).normalized()
		var dotp = x.dot(y)
		if dotp < min_dot:
			outline.remove(j)
		else:
			j += 1
	navpoly.add_outline(outline)


func update():
	for i in range(1, navpoly.get_outline_count()):
		var pl = navpoly.get_outline(i)
		if not Geometry.is_polygon_clockwise(pl):
			pl.invert()
			navpoly.set_outline(i, pl)
	count += 1
	navpoly.clear_polygons()
	navpoly.make_polygons_from_outlines()
	enabled = false
	enabled = true
	.update()

func _draw():
	for i in range(0, navpoly.get_outline_count()):
		var outline = navpoly.get_outline(i)
		var color = Color(1, 0.2, 0)
		for i in range(outline.size()):
			draw_line(outline[i], getm(outline, i+1), color)
			draw_circle(outline[i], 2, Color(1, 0, 1))
