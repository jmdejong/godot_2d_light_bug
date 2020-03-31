extends Node2D


export (int) var nbullets = 1
export (float) var spread = 0.1
export (float) var cooldown = 1
export (bool) var auto = false

var can_shoot = true
var firing = false
var timer = Timer.new()

func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.connect("timeout", self, "gun_cool_down")
	add_child(timer)


func shoot():
	start_shooting()
	firing = false

func start_shooting():
	firing = true
	check_shoot()
	firing = auto
	

func stop_shooting():
	firing = false


func check_shoot():
	if can_shoot and firing:
		can_shoot = false
		timer.start(cooldown)
		do_shoot()

func gun_cool_down():
	can_shoot = true
	check_shoot()

func do_shoot():
	
	for i in range(nbullets):
		var bullet = $Muzzle.create_bullet()
		bullet.global_transform = $Muzzle.global_transform
		bullet.rotation += (randf() * 2 - 1) * spread
		get_node("/root").add_child(bullet)
