extends Weapon

var water = preload("res://Prefabs/Projectiles/WaterDrop.tscn")
var fire = preload("res://Prefabs/Projectiles/FireDrop.tscn")

var can_spawn = false

func hold() -> void:
	if !can_spawn:
		return
	if farming:
		shoot_bullet(water, transform, WeaponEnum.Weapon.WATER)
	else:
		shoot_bullet(fire, transform, WeaponEnum.Weapon.ENEMY)
	can_spawn = false

func _on_timer_timeout():
	can_spawn = true
