extends Weapon

var seeds = preload("res://Prefabs/Plant.tscn")
var bullet = preload("res://Prefabs/Projectiles/Bullet.tscn")

func press() -> void:
	print("Fire Seed Gun")
	shoot_bullet(bullet, transform, WeaponEnum.Weapon.PLANT, seeds)
