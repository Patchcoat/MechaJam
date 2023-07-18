extends Weapon

var seeds = preload("res://Prefabs/Plant.tscn")
var bullet = preload("res://Prefabs/Projectiles/Bullet.tscn")

func press() -> void:
	if farming:
		shoot_bullet(bullet, transform, WeaponEnum.Weapon.PLANT, seeds)
	else:
		shoot_bullet(bullet, transform, WeaponEnum.Weapon.ENEMY, seeds)
