extends Object

export (float) var distance = 1000.0
export (float) var distance_spread = 0.25
export (float) var damage = 1.0
export (float) var width = 1
export (Color) var color = Color("#222")

const Bullet = preload("res://scenes/bullet.tscn")

func create_bullet():
	
	var bullet = Bullet.instance()
	bullet.distance = distance
	bullet.distance_spread = distance_spread
	bullet.damage = damage
	bullet.width = width
	bullet.color = color
	return bullet
