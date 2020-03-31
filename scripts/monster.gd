extends KinematicBody2D


export var speed = 80
export var sight_range = 1000
export var min_attack_range = 20
export var best_range = 500
export var shoot_chance = 0.3
export var accuracy = 0.1

enum Status {IDLE, APPROACH, ATTACK, AIM}
var status = Status.IDLE
var path = PoolVector2Array()

var threshold = 4
var positioning = 0.0 # how well they feel positioned to shoot


			
func _physics_process(delta):
	if status == Status.APPROACH and not path.empty():
		follow_path(delta)
	
func follow_path(delta):
	

	var point = path[0]
	var velocity = (point - position).normalized() * speed
	if position.distance_to(point) < speed * delta:
		path.remove(0)
		if path.size() > 0:
			point = path[0]
		else:
			return
	
	look_at(point)
	move_and_slide(velocity)


func _on_RethinkTimer_timeout():
	path = PoolVector2Array()


func _on_ActTimer_timeout():
	var player = get_node_or_null("/root/main/Player")
	if player == null:
		status = Status.IDLE
	
	if status == Status.IDLE:
		if player and $Eye.can_see(player):
			status = Status.APPROACH
	
	var dist = position.distance_to(player.position)
	
	if status == Status.APPROACH:
		if (dist <= best_range * 1.1 or dist < min_attack_range and randf() < 0.2) and $Eye.can_see(player):
			status = Status.AIM
		elif path.empty():
			var nav = get_node("/root/main/Nav")
			path = nav.get_simple_path(position, player.position)
	
	if status == Status.ATTACK:
		if dist > min_attack_range or not $Eye.can_see(player):
			status = Status.APPROACH
		else:
			look_at(player.global_position)
			rotation += (randf() * 2 - 1) * accuracy
# 			if randf() < shoot_chance:
			$Hand.get_child(0).shoot()
			positioning -= 0.3 * randf() + 0.1
			if positioning <= 0.0:
				if dist > best_range * 1.1 and randf() > 0.5:
					status = Status.APPROACH
				else:
					status = Status.AIM
				
	
	if status == Status.AIM:
		if dist > min_attack_range or not $Eye.can_see(player):
			status = Status.APPROACH
		else:
			look_at(player.global_position)
			rotation += (randf() * 2 - 1) * accuracy
			positioning += randf() * 0.3 + 0.2
			if positioning >= 1.0:
				status = Status.ATTACK
