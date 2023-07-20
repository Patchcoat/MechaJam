extends Area2D

@export var weapon : WeaponEnum.Weapon = WeaponEnum.Weapon.DIG
@export var seeds : PackedScene = null
@export var damage : int = 10
@export var detonation_distance : float = 10

var speed: int = 750
var destination
var last_detonation_distance_squared: float = detonation_distance * detonation_distance

func _physics_process(delta):
	var destination_position
	if destination is Vector2:
		print("Destination")
		destination_position = destination
	else:
		destination_position = destination.transform.position
	position += transform.x * speed * delta
	if global_position.distance_squared_to(destination_position) < last_detonation_distance_squared:
		assert(is_instance_valid(GlobalTileMap.map))
		GlobalTileMap.map.use_tilemap(destination_position, weapon)
		queue_free()
	
	var target_rotation = rotation + get_angle_to(destination_position)
	rotation = lerp(rotation, target_rotation, 0.2)

func _on_body_entered(_body):
	#queue_free()
	pass

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if !area.is_in_group("Enemy"):
		return
	area.get_parent().take_damage.emit(damage)
	queue_free()
