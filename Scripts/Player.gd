extends CharacterBody2D

var bulletSeeds = preload("res://Prefabs/Plants/BulletPlant.tscn")
var missileSeeds = preload("res://Prefabs/Plants/MissilePlant.tscn")
var towerSeeds = preload("res://Prefabs/Plants/TowerPlant.tscn")

@export var move_speed = 300
@export var acceleration = 0.2
@export var camera_offset_strength = 100
@export var bullets = 10 : set = _bullet_set
@export var missiles = 10 : set = _missiles_set
@export var water = 10 : set = _water_set
@export var napalm = 10 : set = _napalm_set
@export var scrap = 0

var move = Vector2(0,0)
var current_weapon_ = WeaponEnum.Weapon.DIG
var menu_visible = false
var farming = true

func _ready():
	%BulletCount.text = "Bullets: " + str(bullets)
	%MissileCount.text = "Missiles: " + str(missiles)
	%WaterCount.text = "Water: " + str(water)
	%NapalmCount.text = "Napalm: " + str(napalm)

func _process(_delta):
	movement()
	mouselook()
	if Input.is_action_pressed("ShowRadialMenu") and !$PlantFight.visible and !$SeedMenu.visible:
		$PlantFight.visible = true
	elif !Input.is_action_pressed("ShowRadialMenu") and $PlantFight.visible:
		$PlantFight.visible = false
	if Input.is_action_pressed("ShowSeedMenu") and !$SeedMenu.visible and !$PlantFight.visible:
		$SeedMenu.visible = true
	elif !Input.is_action_pressed("ShowSeedMenu") and $SeedMenu.visible:
		$SeedMenu.visible = false
	if !$SeedMenu.visible and !$PlantFight.visible:
		activate_weapons()

func _input(event):
	if !$PlantFight.visible and !menu_visible:
		activate_weapons(event)

func activate_weapons(event = null):
	if event == null:
		if $LeftWeapon.get_child_count() == 1:
			var left_weapon = $LeftWeapon.get_children()[0]
			if Input.is_action_pressed("FireLeft"):
				left_weapon.hold(self)
		if $RightWeapon.get_child_count() == 1:
			var right_weapon = $RightWeapon.get_children()[0]
			if Input.is_action_pressed("FireRight"):
				right_weapon.hold(self)
		if $MissileLauncher.get_child_count() == 1:
			var missile_launcher = $MissileLauncher.get_children()[0]
			if Input.is_action_pressed("FireMissile"):
				missile_launcher.hold(self)
		return
	
	if $LeftWeapon.get_child_count() == 1:
		var left_weapon = $LeftWeapon.get_children()[0]
		if event.is_action_pressed("FireLeft"):
			left_weapon.press(self)
		if event.is_action_released("FireLeft"):
			left_weapon.release(self)
	if $RightWeapon.get_child_count() == 1:
		var right_weapon = $RightWeapon.get_children()[0]
		if event.is_action_pressed("FireRight"):
			right_weapon.press(self)
		if event.is_action_released("FireRight"):
			right_weapon.release(self)
	if $MissileLauncher.get_child_count() == 1:
		var missile_launcher = $MissileLauncher.get_children()[0]
		if event.is_action_pressed("FireMissile"):
			missile_launcher.press(self)
		if event.is_action_released("FireMissile"):
			missile_launcher.release(self)

func mouselook():
	var mouse_position = get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size
	mouse_position = mouse_position * 2 - Vector2(1,1)
	$Camera2D.offset = mouse_position * camera_offset_strength

func movement():
	if Input.is_action_pressed("MoveUp"):
		move.y = -1
	elif Input.is_action_pressed("MoveDown"):
		move.y = 1
	else:
		move.y = 0
	if Input.is_action_pressed("MoveLeft"):
		move.x = -1
	elif Input.is_action_pressed("MoveRight"):
		move.x = 1
	else:
		move.x = 0
	velocity.x = lerp(velocity.x, move.x * move_speed, acceleration)
	velocity.y = lerp(velocity.y, move.y * move_speed, acceleration)
	move_and_slide()

func _bullet_set(new_bullets):
	bullets = new_bullets
	%BulletCount.text = "Bullets: " + str(bullets)

func _missiles_set(new_missiles):
	missiles = new_missiles
	%MissileCount.text = "Missiles: " + str(missiles)

func _water_set(new_water):
	water = new_water
	%WaterCount.text = "Water: " + str(water)

func _napalm_set(new_napalm):
	napalm = new_napalm
	%NapalmCount.text = "Napalm: " + str(napalm)

func _on_plant_pressed():
	var left_weapon = $LeftWeapon.get_children()[0]
	var right_weapon = $RightWeapon.get_children()[0]
	var missile_launcher = $MissileLauncher.get_children()[0]
	left_weapon.farming = true
	right_weapon.farming = true
	missile_launcher.farming = true

func _on_fight_pressed():
	var left_weapon = $LeftWeapon.get_children()[0]
	var right_weapon = $RightWeapon.get_children()[0]
	var missile_launcher = $MissileLauncher.get_children()[0]
	left_weapon.farming = false
	right_weapon.farming = false
	missile_launcher.farming = false

func _on_bullet_seeds_pressed():
	$LeftWeapon/SeedGun.set_seeds(bulletSeeds)

func _on_missile_seeds_pressed():
	$LeftWeapon/SeedGun.set_seeds(missileSeeds)

func _on_turret_seeds_pressed():
	$LeftWeapon/SeedGun.set_seeds(towerSeeds)

func _on_radial_menu_hovered(child):
	%Selection.text = child.name

func _on_radial2_menu_hovered(child):
	%Selection2.text = child.name

func _on_item_pickup_area_entered(area):
	if area.is_in_group("Pickup"):
		if area.is_in_group("Bullet"):
			bullets += area.quantity
		elif area.is_in_group("Missile"):
			missiles += area.quantity
		area.queue_free()
