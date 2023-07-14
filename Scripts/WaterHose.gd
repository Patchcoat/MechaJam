extends Weapon

var water = preload("res://Prefabs/Projectiles/WaterDrop.tscn")

var can_spawn = false

func hold() -> void:
	if !can_spawn:
		return
	shoot_bullet(water, transform, WeaponEnum.Weapon.WATER)
	can_spawn = false

func _on_timer_timeout():
	can_spawn = true
