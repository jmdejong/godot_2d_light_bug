extends Node

export (float) var health = 1
enum DeathReaction {IGNORE, DESTROY, DELEGATE}
export (DeathReaction) var on_death = DeathReaction.DESTROY

signal die


func damage(amount):
	health -= amount
	if health <= 0:
		die()


func die():
	emit_signal("die")
	match on_death:
		DeathReaction.IGNORE:
			pass
		DeathReaction.DESTROY:
			get_parent().queue_free()
		DeathReaction.DELEGATE:
			get_parent().die()


