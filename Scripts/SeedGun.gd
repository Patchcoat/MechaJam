extends Weapon

var seeds = preload("res://Prefabs/Plants/BulletPlant.tscn")
var bullet = preload("res://Prefabs/Projectiles/Bullet.tscn")

var can_spawn = true

func shoot(player) -> void:
	if player.bullets <= 0 or !can_spawn:
		return
	player.bullets -= 1
	if farming:
		shoot_bullet(bullet, transform, WeaponEnum.Weapon.PLANT, seeds)
	else:
		shoot_bullet(bullet, transform, WeaponEnum.Weapon.ENEMY)
	can_spawn = false

func set_seeds(new_seeds):
	seeds = new_seeds

func press(_player) -> void:
	$Timer.start()

func hold(player) -> void:
	shoot(player)

func release(_player) -> void:
	$Timer.stop()

func _on_timer_timeout():
	can_spawn = true
