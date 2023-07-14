extends CharacterBody2D

@export var move_speed = 300
@export var acceleration = 0.2
@export var camera_offset_strength = 100
@export var bullets = 0 : set = _bullet_set
@export var missiles = 0 : set = _missiles_set
@export var scrap = 0

var move = Vector2(0,0)
var current_weapon = WeaponEnum.Weapon.DIG
var menu_visible = false

func _process(_delta):
	movement()
	mouselook()
	if Input.is_action_pressed("ShowRadialMenu") and !$Control.visible:
		$Control.visible = true
	elif !Input.is_action_pressed("ShowRadialMenu") and $Control.visible:
		$Control.visible = false
	activate_weapons()

func _input(event):
	if !$Control.visible and !menu_visible:
		activate_weapons(event)
	if event.is_action_pressed("OpenMechMenu"):
		%UIAnimationPlayer.play("SlideOut" if menu_visible else "SlideIn")
		menu_visible = !menu_visible
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			Music.transition("Song1")
		elif event.keycode == KEY_R:
			Music.transition("Song2")

func activate_weapons(event = null):
	if event == null:
		if $LeftWeapon.get_child_count() == 1:
			var left_weapon = $LeftWeapon.get_children()[0]
			if Input.is_action_pressed("FireLeft"):
				left_weapon.hold()
		if $RightWeapon.get_child_count() == 1:
			var right_weapon = $RightWeapon.get_children()[0]
			if Input.is_action_pressed("FireRight"):
				right_weapon.hold()
		if $MissileLauncher.get_child_count() == 1:
			var missile_launcher = $MissileLauncher.get_children()[0]
			if Input.is_action_pressed("FireMissile"):
				missile_launcher.hold()
		return
	
	if $LeftWeapon.get_child_count() == 1:
		var left_weapon = $LeftWeapon.get_children()[0]
		if event.is_action_pressed("FireLeft"):
			left_weapon.press()
		if event.is_action_released("FireLeft"):
			left_weapon.release()
	if $RightWeapon.get_child_count() == 1:
		var right_weapon = $RightWeapon.get_children()[0]
		if event.is_action_pressed("FireRight"):
			right_weapon.press()
		if event.is_action_released("FireRight"):
			right_weapon.release()
	if $MissileLauncher.get_child_count() == 1:
		var missile_launcher = $MissileLauncher.get_children()[0]
		if event.is_action_pressed("FireMissile"):
			missile_launcher.press()
		if event.is_action_released("FireMissile"):
			missile_launcher.release()

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
	%MissileCount.next = "Missiles: " + str(missiles)

func _on_dig_pressed():
	current_weapon = WeaponEnum.Weapon.DIG

func _on_water_pressed():
	current_weapon = WeaponEnum.Weapon.WATER

func _on_plant_pressed():
	current_weapon = WeaponEnum.Weapon.PLANT

func _on_radial_menu_hovered(child):
	%Selection.text = child.name

func _on_item_pickup_area_entered(area):
	if area.is_in_group("Pickup"):
		if area.is_in_group("Bullet"):
			bullets += area.quantity
		area.queue_free()
