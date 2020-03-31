extends RayCast2D


export var sight_range = 500



func can_see(obj):
	return sight_distance_to(obj) >=0

func sight_distance_to(obj):
	var pos = to_local(obj.global_position)
	set_cast_to(pos.normalized() * sight_range)
	force_raycast_update()
	if is_colliding() and get_collider() == obj:
		return global_position.distance_to(get_collision_point())
	else:
		return -1
