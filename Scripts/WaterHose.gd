extends Weapon

var water = preload("res://Prefabs/Projectiles/WaterDrop.tscn")
var fire = preload("res://Prefabs/Projectiles/FireDrop.tscn")

var can_spawn = false

func hold(player) -> void:
	if !can_spawn:
		return
	if farming and player.water > 0:
		player.water -= 1
		shoot_bullet(water, transform, WeaponEnum.Weapon.WATER)
	elif !farming and player.napalm > 0:
		player.napalm -= 1
		shoot_bullet(fire, transform, WeaponEnum.Weapon.ENEMY)
	can_spawn = false

func _on_timer_timeout():
	can_spawn = true
