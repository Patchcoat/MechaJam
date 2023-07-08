extends Area2D

@export var weapon : WeaponEnum.Weapon = WeaponEnum.Weapon.DIG
@export var seeds : PackedScene = null

var speed: int = 750
var destination: Vector2
var last_distance: float = INF

func _physics_process(delta):
	position += transform.x * speed * delta
	if last_distance < global_position.distance_squared_to(destination):
		assert(is_instance_valid(GlobalTileMap.map))
		GlobalTileMap.map.use_tilemap(destination, weapon, seeds)
		queue_free()
	last_distance  = global_position.distance_squared_to(destination)

func _on_body_entered(_body):
	#queue_free()
	pass

func _on_timer_timeout():
	queue_free()
