extends CharacterBody2D

signal take_damage(damage)

@export var health = 100

var alive : bool = true

func _ready():
	take_damage.connect(hit)

func hit(damage):
	health -= damage
	if health <= 0:
		die()
	print(health)

func die():
	alive = false
	# TODO animate death
	queue_free()
