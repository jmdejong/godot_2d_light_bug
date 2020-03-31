extends Camera2D

export var target_zoom = 1
export var max_zoom = 8
export var min_zoom = 0.5
export var zoom_step = sqrt(sqrt(2))
export var zoom_speed_linear = 8
export var zoom_speed_static = 1


var target


func move_to(origin, destination, step_size):
	var dif = destination - origin
	if step_size >= dif.length():
		return destination
	return origin + dif.normalized() * step_size

func _ready():
	change_zoom(1)

func change_zoom(change):
	target_zoom *= change
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	target = Vector2(target_zoom, target_zoom)

func zoom_out():
	change_zoom(zoom_step)

func zoom_in():
	change_zoom(1/zoom_step)

func _input(event):
	if Input.is_action_pressed('zoom_out'):
		zoom_out()
	elif Input.is_action_pressed('zoom_in'):
		zoom_in()
	
func _process(delta):
	zoom = zoom.linear_interpolate(target, delta * zoom_speed_linear)
	zoom = move_to(zoom, target, delta*zoom_speed_static)
