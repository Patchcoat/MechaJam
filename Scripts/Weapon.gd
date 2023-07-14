extends Node2D
class_name Weapon

func press() -> void:
	pass

func hold() -> void:
	pass

func release() -> void:
	pass

func shoot_bullet(bullet, spawn_position, current_weapon, seeds=null):
	var new_bullet = bullet.instantiate()
	new_bullet.weapon = current_weapon
	if (seeds != null):
		new_bullet.seeds = seeds
	add_child(new_bullet)
	new_bullet.transform = spawn_position
	new_bullet.look_at(get_global_mouse_position())
	new_bullet.destination = get_global_mouse_position()

func fire_missile(missile, spawn_position, new_rotation, target):
	missile.global_transform = spawn_position
	missile.rotation = new_rotation
	missile.destination = target
	
